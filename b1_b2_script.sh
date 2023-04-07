#!/usr/local/bin/bash

# DENOM="commnet001"
# FLOW_TYPE="f11"
DENOM="$1"
FLOW_TYPE="$2"
NFT_ID="$3"
if [ "$DENOM" = "" ] || [ "$FLOW_TYPE" = "" ] || [ "$NFT_ID" = "" ]; then
    echo "INPUT DENOM, FLOW_TYPE, NFT_ID"
    exit 1
fi

PROD=
PROD=1

SLEEP_ITER=4
START_FROM_STEP=4
START_FROM_STEP=
START_FROM_DENOM=

Lista="f1#i1s1j1u1o1i
f2#i1s1j1u1o2i
f3#i1s1j1u2o1i
f4#i1s1j1u2o2i
f5#i1s1j2u1o1i
f6#i1s1j2u1o2i
f7#i1s1j2u2o1i
f8#i1s1j2u2o2i
f9#i1s2j1u1o1i
f10#i1s2j1u1o2i
f11#i1s2j1u2o1i
f12#i1s2j1u2o2i
f13#i1s2j2u1o1i
f14#i1s2j2u1o2i
f15#i1s2j2u2o1i
f16#i1s2j2u2o2i
f17#i2s1j1u1o1i
f18#i2s1j1u1o2i
f19#i2s1j1u2o1i
f20#i2s1j1u2o2i
f21#i2s1j2u1o1i
f22#i2s1j2u1o2i
f23#i2s1j2u2o1i
f24#i2s1j2u2o2i
f25#i2s2j1u1o1i
f26#i2s2j1u1o2i
f27#i2s2j1u2o1i
f28#i2s2j1u2o2i
f29#i2s2j2u1o1i
f30#i2s2j2u1o2i
f31#i2s2j2u2o1i
f32#i2s2j2u2o2i"

SDATE=$(date)
STIME=$(date +%s)
echo "########################### BEGIN THE RACE AT $SDATE ###########################"
echo "[OK] Extract correct flow $FLOW_TYPE"
FOUND_FLOW=
for TASK in $Lista; do
    PREVIFS=$IFS
    IFS="#"
    FIEALD_COUNTER=0
    for VAL in $TASK; do
        #echo $VAL
        if [[ $FIEALD_COUNTER = 0 ]]; then
            IDX=$VAL
        else
            NFT_PATH=$VAL
        fi
        FIEALD_COUNTER=$(($FIEALD_COUNTER + 1))
    done
    if [[ $IDX = $FLOW_TYPE ]]; then
        FOUND_FLOW=1
        break
    fi
done
if [[ ! -n $FOUND_FLOW ]]; then
    echo "[ERROR] Flow $FLOW_TYPE not exits"
    exit 1
fi

echo "[OK] Found correct flow $IDX"
echo "[OK] Try to elaborate path $NFT_PATH"
echo "============================== START ================================"
CUR_PATH=${NFT_PATH:0:1}
STEP=1
CUR_DENOM=$DENOM
for ((i = 0; i < ${#NFT_PATH}; i += 2)); do

    CH="${NFT_PATH:$i:3}"
    CUR_PATH=$CUR_PATH${CH:1:3}
    if [[ $CUR_PATH = $PREV_PATH ]]; then
        break
    fi
    echo "---------------------------------------------------"
    echo "[OK] Start step $STEP"
    echo ""
    echo "  SEGMENT: $CH"
    src_chain=${CH:0:1}
    chan_numb=${CH:1:1}
    dst_chain=${CH:2:1}
    echo "  SRC: $src_chain - NUM: $chan_numb - DST: $dst_chain - CUR_PATH: $CUR_PATH"

    STEP_FAIL=1
    MAX_STEP_TRY=2
    STEP_TRIES=0
    NO_CHECK=
    CHECK_STEP=$(($STEP - 1))
    if [[ -n $START_FROM_STEP ]] && [[ $START_FROM_STEP -gt $CHECK_STEP ]]; then
        NO_CHECK=1
    fi
    while [[ $STEP_FAIL -gt 0 ]]; do
        if [[ ! -n $START_FROM_STEP ]] || [[ $START_FROM_STEP -lt $STEP ]]; then
            echo "  [OK] Exec transfer"

            if [[ ! -n $PROD ]]; then
                ./transfer_nft.sh $CUR_DENOM $NFT_ID $src_chain $chan_numb $dst_chain $PROD
            else
                CODE_TRANSFER=1
                MAX_TRY=3
                TRYS=0
                while [[ $CODE_TRANSFER -gt 0 ]]; do
                    echo -ne "   [OK] Round $TRYS for transfer of step round $STEP_TRIES\033[0K\r"
                    HASH=$(./transfer_nft.sh $CUR_DENOM $NFT_ID $src_chain $chan_numb $dst_chain $PROD 2>/dev/null)
                    CODE_TRANSFER=$?
                    if [[ $TRYS -gt $MAX_TRY ]]; then
                        echo "  [ERROR] Exec transfer FAILED. It should be a new step round"
                        if [[ $STEP_TRIES -lt 1 ]]; then
                            echo "  [ERROR] Race FAILED."
                            echo "  ./get_denom_hash.sh $NFT_ID $dst_chain \"$ROUND_PATH\" $PROD"
                            echo "  ./transfer_nft.sh $CUR_DENOM $NFT_ID $src_chain $chan_numb $dst_chain $PROD"
                            exit 1
                        else
                            CODE_TRANSFER=0
                        fi
                        #continue
                        #exit 1
                    fi
                    TRYS=$(($TRYS + 1))
                done
            fi
            if [[ -n $HASH ]]; then
                echo "  [OK] Got hash transfer $HASH and confirm"
            fi
        fi

        ROUND_PATH=$(./echo_path2.sh $DENOM $CUR_PATH)
        if [[ ! -n $PROD ]]; then
            echo "./get_denom_hash.sh $NFT_ID $dst_chain \"$ROUND_PATH\""
            ./get_denom_hash.sh $NFT_ID $dst_chain "$ROUND_PATH" $PROD
        else
            CODE_VER=1
            MAX_TRY=12
            MID_TRY=6
            TRIES=0
            PREV_DENOM=$CUR_DENOM
            STEP_FAIL=0
            while [[ $CODE_VER -gt 0 ]]; do
                echo -ne "   [OK] Round $TRIES for get new denom of step round $STEP_TRIES\033[0K\r"
                #echo "   [OK] Round $TRIES for get new denom of step round $STEP_TRIES"
                #if [[ -n $NO_CHECK ]]; then
                #echo "   [OK] No check needed"
                #fi
                #CUR_DENOM=$(./get_denom_hash.sh $NFT_ID $dst_chain "$ROUND_PATH" $PROD $NO_CHECK 2>/dev/null)
                CUR_DENOM=$(./get_denom_hash.sh $NFT_ID $dst_chain "$ROUND_PATH" $PROD 2>/dev/null)
                CODE_VER=$?
                if [[ $CODE_VER -gt 0 ]]; then
                    sleep $SLEEP_ITER
                fi
                if [[ $TRIES -gt $MAX_TRY ]]; then
                    STEP_FAIL=1
                    echo "  [ERROR] Cannot obtain new DENOM. TRY AGAIN STEP "
                    CUR_DENOM=$PREV_DENOM
                    CODE_VER=0
                    #exit 1
                fi
                if [[ $TRIES -eq $MID_TRY ]]; then
                    HASH=$(./transfer_nft.sh $PREV_DENOM $NFT_ID $src_chain $chan_numb $dst_chain $PROD 2>/dev/null)
                    CODE_TRANSFER=$?
                    if [[ $CODE_TRANSFER -lt 1 ]]; then
                        echo "  [OK] Got hash transfer $HASH and confirm in MID_TRY"
                        MAX_TRY=$MAX_TRY+$MID_TRY
                    fi
                fi
                TRIES=$(($TRIES + 1))
            done
        fi
        if [[ ! -n $PROD ]]; then
            STEP_FAIL=0
        fi

        if [[ $STEP_TRIES -gt $MAX_STEP_TRY ]]; then
            echo "  [ERROR] Can't obtain new DENOM'. EXIT FROM THE RACE FOREVER :("
            exit 1
        fi
        STEP_TRIES=$(($STEP_TRIES + 1))
    done

    echo "  [OK] Got new denom $CUR_DENOM. Go haed... "
    PREV_PATH=$CUR_PATH
    echo ""
    echo "[OK] End step $STEP"
    echo "---------------------------------------------------"
    #sleep $SLEEP_ITER
    #sleep 1
    STEP=$(($STEP + 1))
done
if [[ -n $FINAL_ADDRESS ]]; then
    echo "[OK] Now try to send the nft to new owner"
    if [[ ! -n $PROD ]]; then
        echo ./transfer_owner_nft.sh $CUR_DENOM $NFT_ID i $FINAL_ADDRESS $PROD
    else
        CODE_TRANSFER=1
        MAX_TRY=3
        TRYS=0
        while [[ $CODE_TRANSFER -gt 0 ]]; do
            echo -ne "   [OK] Round $TRYS for transfer of step round $STEP_TRIES\033[0K\r"
            HASH=$(./transfer_nft.sh $CUR_DENOM $NFT_ID $src_chain $chan_numb $dst_chain $PROD 2>/dev/null)
            CODE_TRANSFER=$?
            if [[ $TRYS -gt $MAX_TRY ]]; then
                echo "  [ERROR] Exec transfer owner FAILED. Try manualy"
                echo ./transfer_owner_nft.sh $CUR_DENOM $NFT_ID i $FINAL_ADDRESS $PROD
            fi
            TRYS=$(($TRYS + 1))
        done
    fi
fi

echo "IF YOU ARE HERE GRAT WORK!!!!"
echo "============================== END ================================"
EDATE=$(date)
ETIME=$(date +%s)
TOTAL_TIME=$(($ETIME - $STIME))
echo "########################### END THE RACE AT $EDATE IN $TOTAL_TIME SECS ###########################"

exit
