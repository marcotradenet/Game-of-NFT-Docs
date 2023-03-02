# Generate GoN addresses

## Generate mnemonic

To generate your mnemonic you can use any `cosmos-sdk` software or `Keplr` or any other app that use the bip39 standard. I used `simd` app from `cosmos-sdk`

```bash
simd keys add GoN-Mnemonic --dry-run
```

In output it should show the 24 words of the mnemonic and a cosmos address look like this `cosmos1abcdefghilmnopqrstuvzabcdefghilmnopqrs`. Save the mnemonic in a safe place for use in the following steps.


## Install Iris and generate address

Installation details from source: https://www.irisnet.org/docs/get-started/install.html


```bash
git clone https://github.com/irisnet/irishub
cd irishub
git checkout v1.4.1-gon-testnet
make install
```
Check your version
```bash
iris version
```

It should be `1.4.1-gon-testnet`


Generete your address

```bash
iris keys add GoN-Address --recover --keyring-backend test 
```

enter your mnemonic when prompt asks for it. The address should look something like this `iaa1abcdefghilmnopqrstuvzabcdefghilmnopqrs`

**hrp**: `iaa`



## Install Stargaze and generate address

Installation details from source: https://github.com/public-awesome/stargaze

```bash
git clone https://github.com/public-awesome/stargaze.git
cd stargaze
git checkout v8.1.0
make install
```
Check your version
```bash
starsd version
```

It should be `8.1.0`

Generete your address

```bash
starsd keys add GoN-Address --recover
```

enter your mnemonic when prompt asks for it. The address should look something like this `stars1abcdefghilmnopqrstuvzabcdefghilmnopqrs`


**hrp**: `stars`



## Install Juno and generate address

Installation details from source: https://docs.junonetwork.io/validators/getting-setup

```bash
git clone https://github.com/CosmosContracts/juno.git
cd juno
git checkout v12.0.0
make install
```

Check your version
```bash
junod version
```

It should be `v12.0.0`

Generete your address

```bash
junod keys add GoN-Address --recover
```

enter your mnemonic when prompt asks for it. The address should look something like this `juno1abcdefghilmnopqrstuvzabcdefghilmnopqrs`


**hrp**: `juno`



## Install Uptickd and generate address

Details details from source: https://github.com/UptickNetwork/uptick
**WARNING**: I have not been able to compile with OSX. I used a linux vm.

```bash
git clone https://github.com/UptickNetwork/uptick.git
cd uptick
git checkout v0.2.6
make install
```

Check your version
```bash
uptickd version
```

It should be `v0.2.6`


Generete your address

```bash
uptickd keys add GoN-Address --recover
```

enter your mnemonic when prompt asks for it. The address should look something like this `uptick1abcdefghilmnopqrstuvzabcdefghilmnopqrs`



**hrp**: `uptick`

## Install Omniflix and generate address


Installation details from source: https://github.com/OmniFlix/omniflixhub.


```bash
git clone https://github.com/Omniflix/omniflixhub.git
cd omniflixhub
git checkout v0.9.0-gon-rc7
go mod tidy
make install
```

Check your version
```bash
omniflixhubd version
```

It should be `0.9.0-gon-rc7`


Generete your address

```bash
omniflixhubd keys add GoN-Address --recover
```

enter your mnemonic when prompt asks for it. The address should look something like this `omniflix1abcdefghilmnopqrstuvzabcdefghilmnopqrs`


**hrp**: `omniflix`




