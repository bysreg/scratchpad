
'''
    replace every files in the current folder with new name from replacement

'''


def re_replace(pattern, replacement, dry_run):
    import glob
    import re
    import os
    for filename in glob.glob('*'):
        new_name = re.sub(pattern, replacement, filename)
        if not dry_run:
            os.rename(filename, new_name)
        else:
            print(new_name)
