#!/usr/bin/python3

'''
Generates a strong random password, user chooses the length
Useful (and safer) way to quickly generate a new and strong pass without having to access a website
'''

import random
import string


def welcome():
    print("\n [#] Password Generator")
    start()


def start():
    length = pass_length()
    symbols = "!@#$%&*,.-+="
    characters = string.ascii_letters + string.digits + symbols  # Optional for more symbols: string.punctuation
    password = pass_generator(length, characters)
    prints_result(password)
    new_password()


def pass_length():
    length = 0
    while length < 1:
        length = int(input("\n [>] Password Length: "))
        if length < 1:
            print("\n ** Please type the desired password length! ** ")
            continue
        else:
            break
    return length


def pass_generator(length, characters):
    return ''.join(random.choice(characters) for i in range(length))


def prints_result(password):
    print("\n [+] Your password:",password)


def new_password():
    new_pass = ''
    while new_pass != "y" or new_pass != "n":
        new_pass = input("\n [?] Generate a new password (y/n)? ")
        if new_pass == "y":
            start()
        elif new_pass == "n":
            print("")
            exit()
        else:
            print("\n ** Please choose one of the options! **")
            continue


if __name__ == "__main__":
    welcome()
