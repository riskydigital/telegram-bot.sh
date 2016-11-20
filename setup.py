#!/usr/bin/env python

from setuptools import setup
import os

os.chdir(os.path.normpath(os.path.join(os.path.abspath(__file__), os.pardir)))

setup(
    name='telegram-bot.sh',
    scripts=[
        'telegram-bot.sh',
    ],
    version='0.2',
    description="Telegram bot written in shell scripting",
    long_description="",
    author='Alessandro Rosetti',
    author_email='alessandro.rosetti@gmail.com',
    url='https://github.com/hexvar/telegram-bot.sh',
    classifiers=[
        "Programming Language :: Unix Shell",
        "License :: OSI Approved :: GPLv3",
        "Intended Audience :: System Administrators",
        "Operating System :: POSIX :: Linux",
        "Topic :: Utilities"
    ]
)
