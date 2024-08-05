import math
import os
import requests
import subprocess
import sys

'''
This is the second rendition of diceware.py that cleans up code by removing global variables
and adhering to some Python best practices. Error handling has been improved, and the API 
call has been simplified. 'get_word_list()' is replaced and simplified with 'generate_password()'

'''



# Constants 
'''
WORDLIST_FILES = {
    '4': 'wordlist4.txt',
    '5': 'wordlist5.txt'
}
'''
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))  # Get the script's directory
WORDLIST_FILES = {
    '4': os.path.join(SCRIPT_DIR, 'wordlist4.txt'),
    '5': os.path.join(SCRIPT_DIR, 'wordlist5.txt')
}
QRNG_API_URL = "http://qrng.ethz.ch/api/randint"
OUTPUT_FILE = 'password.out'



############################### FUNCTION DEFINTIONS ###############################

def get_roll_num():
    # Prompts the user to select the number of words for the password.
    print('\n\n****************** WARNING *******************') 
    print('It is recommended you choose 5 words to ensure \nmaximum entropy of the generated password.')
    print('**********************************************\n')
    
    while True:
        roll_num = input("Please select the number of words you desire: \n (4) \n (5) \n")
        if roll_num in WORDLIST_FILES:
            return roll_num
        else:
            print("Invalid choice. Please select either '4' or '5'.")



def read_words(file_path):
    # Reads the wordlist file and returns a dictionary mapping indices to words.
    word_dict = {}
    try:
        with open(file_path, 'r') as file:
            for line in file:
                line = line.strip()
                if line:
                    parts = line.split()
                    if len(parts) >= 2:
                        key = parts[0]
                        value = ' '.join(parts[1:])
                        word_dict[key] = value
    except FileNotFoundError:
        print(f"Error: File '{file_path}' not found.")
        sys.exit(1)
    return word_dict



def get_random_integers(size):
    # Get quantum random integers from the QRNG API.
    params = {'min': 1, 'max': 6, 'size': size}
    try:
        response = requests.get(QRNG_API_URL, params=params)
        response.raise_for_status()  
        return response.json()['result']
    except requests.exceptions.RequestException as e:
        print("Error retrieving random numbers from API:", e)
        sys.exit(1)



def find_word(idx, word_dict):
    # Finds the word associated with the given index in the word dictionary.
    return word_dict.get(idx, '')



def generate_password(roll_num, word_dict):
    # Generates a password using quantum random numbers and a wordlist.
    pw_lst = []
    for _ in range(int(roll_num)):
        index_raw = get_random_integers(int(roll_num))
        index = ''.join(map(str, index_raw))
        word = find_word(index, word_dict)
        pw_lst.append(word)
    return ''.join(pw_lst)



def save_password(output_file, password):
    # Saves the generated password to a file.
    with open(output_file, 'w') as file:
        file.write(password)
    os.chmod(output_file, 0o600)
    print(f"Password saved to {output_file}.")



def lastpass_export(password):
    # Exports the generated password to LastPass.
    password_name = input("Please enter the associated name for your password: ")
    user_email = input("Please enter your LastPass email: ")

    lpass_login = ["lpass", "login", user_email]
    try:
        subprocess.run(lpass_login, check=True, text=True)
        print("Logged into LastPass successfully.")
    except subprocess.CalledProcessError as e:
        print(f"Failed to login to LastPass: {e.stderr}")
        return

    lpass_add = ['lpass', 'add', password_name, '--non-interactive']
    input_string = f"Password Name: {password_name}\nPassword: {password}"
    process = subprocess.Popen(lpass_add, stdin=subprocess.PIPE)
    process.communicate(input=input_string.encode())
    
    if process.returncode != 0:
        print("Failed to add entry to LastPass.")
    else:
        print("Password successfully saved to LastPass.")



def calculate_entropy(roll_num):
    # Calculates and prints the entropy of the generated password.
    charset_size = 1296 if roll_num == '4' else 7776
    length = int(roll_num)
    entropy = int(length * math.log2(charset_size))
    print(f"The final entropy of the password is about: {entropy} bits")





####################### MAIN FUNCTION AND CALL ##########################

def main():
    roll_num = get_roll_num()
    file_path = WORDLIST_FILES[roll_num]
    word_dict = read_words(file_path)
    password = generate_password(roll_num, word_dict)

    if input("Would you like to save this password to your local directory? (Yes/No)\n").lower().strip() == 'yes':
        save_password(OUTPUT_FILE, password)
    
    if input("Would you like to export this password to LastPass? (Yes/No)\n").lower().strip() == 'yes':
        lastpass_export(password)
    
    calculate_entropy(roll_num)

if __name__ == "__main__":
    main()

#########################################################################
