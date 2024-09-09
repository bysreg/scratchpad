import glob
import re
import os


def re_replace(pattern, replacement, dry_run):
    '''Replace every files in the current folder with new name '''
    for filename in glob.glob('*'):
        new_name = re.sub(pattern, replacement, filename)
        if not dry_run:
            os.rename(filename, new_name)
        else:
            print(new_name)


def get_file_names():
    ''' return all file names in the current folder separated by ";". '''
    ret = ""
    for filename in glob.glob('*'):
        ret += filename + ";"
    return ret
