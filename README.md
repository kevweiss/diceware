# diceware
Generate and export diceware passwords to LastPass



This is the second rendition of diceware.py that cleans up code by removing global variables
and adhering to some Pyhton 'best practices'. Error handling has been improved, and the API 
call has been simplified. 'get_word_list()' is replaced and simplified with 'generate_password()'

This program generates a random password using the files wordlist4.txt and wordlist5.txt.
Password is generated by 'rolling' a die either 4 or 5 times to generate an index that is
associated with a word in one of the two lists. For passwords of length 4, each word 
requires 4 rolls (example index: 1234). For passwords of length 5, each word requires 5 rolls 
(example index: 12345). Hence either 16 or 25 random numbers are required. The password is 
then saved to password.out. Additionally, using lastpass-cli, passwords generated by this 
script can be exported directly to your lastpass vault.

The rolls are generated by pulling qunatum random numbers from a QRNG API url, namely 
"http://qrng.ethz.ch/api/randint". This is a QRNG from ETH Zurich. Either 4 or 5 calls are
made to the API depending on the number of rolls you choose (each call pulls 4 or 5 random
numbers to create an index of length 4 or 5). More details regarding their approach can be 
found here: http://qrng.ethz.ch. A paper descriping QRNG can be found at https://arxiv.org/pdf/1311.4547
and I have found it to be an excellent source for understanding the topic.

Note: This code can be easily extended to generate longer, higher entropy passwords, if 
a list of words has the correct indexing. Further development may include robustness for 
all types of indicies. Additionally reducing the API calls to 1 per run may be possible.


## Setup Instructions

1. Clone the repository:
    ```bash
    git clone https://github.com/kevweiss/diceware.git
    cd diceware
    ```

2. Create and activate a virtual environment:
    ```bash
    python3 -m venv venv
    source venv/bin/activate  # On Windows use `venv\Scripts\activate`
    ```

3. Install dependencies:
    ```bash
    pip install -r requirements.txt
    ```

4. Run program:
   ```bash
    python3 diceware_2.0.py
    ```
