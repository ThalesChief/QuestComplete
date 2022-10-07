import fnmatch
from gettext import find
import os
import shutil
import sys
from typing import BinaryIO

src_dir = sys.argv[1] 
dst_dir = sys.argv[2]
extension_lua = "*.lua"

extension_lua = "*.txt"

extension_toc = "*.toc"

print ("Source Dir: ", src_dir, "\n", "Destination Dir: ",dst_dir, "\n", "Extension: ", extension_lua)


def convert_files():
    def failed(exec):
        raise exec
        
    for dirpath, dirs, files in os.walk(src_dir, topdown=True, onerror=failed):
        for file in fnmatch.filter(files,extension_lua):
            with open(os.path.join(dirpath, file), "r") as f:
                src_file = BinaryIO(f)
                with open("demo.bin", "wb") as f_in:                
                    dest_file = BinaryIO(f_in)
                    f_in.seek(0)
                    f_in.write(src_file.read())            
        break


def find_files():
    def failed(exec):
        raise exec
    
    for dirpath, dirs, files in os.walk(src_dir, topdown=True, onerror=failed):
        for file in fnmatch.filter(files,extension_lua):
            shutil.copy2(os.path.join(dirpath, file), dst_dir)
        break
    
    for dirpath, dirs, files in os.walk(src_dir, topdown=True, onerror=failed):
        for file in fnmatch.filter(files,extension_toc):
            shutil.copy2(os.path.join(dirpath, file), dst_dir)
        break

if __name__ == "__main__":
    # find_files()
    convert_files()

