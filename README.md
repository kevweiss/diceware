# diceware
Command line tool to generate and export diceware passwords to LastPass (Linux only)


This program generates a random password using the files wordlist4.txt and wordlist5.txt. Password is generated by rolling a die either 4 or 5 times to generate an index that is associated with a word in one of the two lists. For passwords of length 4, each word requires 4 rolls (example index: 1234). For passwords of length 5, each word requires 5 rolls (example index: 12345). Hence either 16 or 25 random numbers are required. The password is then (optionally) saved to password.out. Additionally, using lastpass-cli, passwords generated by this 
script can be exported directly to your lastpass vault.

The rolls are generated by pulling qunatum random numbers from a QRNG API url, namely "http://qrng.ethz.ch/api/randint". This is a QRNG from ETH Zurich. The program has recently been altered to require only a single API call, regardless of password length. QRNG takes a truly random process, where information created is uniformly distributed and completely independent of all information available in advance, and applies a post-process hashing algorithm to account for imperfections in equipment. More details regarding their approach can be found here: http://qrng.ethz.ch. A paper descriping QRNG can be found at https://arxiv.org/pdf/1311.4547 and I have found it to be an excellent source for understanding the topic. For passwords of length 4, there is a roughly 1 in 3 quadrillion chance of correctly guessing the generated password (41 bits). For passwords of length 5, the odds increase to roughly 1 in 28 quintillion (64 bits). 


## Setup Instructions

1. Open a Linux enviornment and navigate to the folder where you wish to install the program. 


2. Run diceware_install.sh with:
    ```bash
    wget -qO- https://raw.githubusercontent.com/kevweiss/diceware/main/diceware_install.sh | bash 
    ```
   This will install the command line tool 'diceware_gen' and it's dependancies. 


3. Run in the command line:
    ```
    source ~/.bashrc
    ```

