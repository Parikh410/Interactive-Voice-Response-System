Dependencies Requirements


# Python Pip 
    apt-get install python-pip

# Git
    apt-get install git

# Python development tools
    apt-get install python-dev

# Python-setuptools
    apt-get install python-setuptools
    
# Twisted 12.1.0
    cd /usr/src/
    wget https://pypi.python.org/packages/source/T/Twisted/Twisted-12.1.0.tar.bz2#md5=f396f1d6f5321e869c2f89b2196a9eb5
    tar xvjf Twisted-12.1.0.tar.bz2
    cd Twisted-12.1.0
    python setup.py install
    
# Mysql-server
    apt-get install mysql-server

# Starpy
    cd /usr/src/
    wget -O starpy.tar.gz http://downloads.sourceforge.net/project/starpy/starpy/1.0.0a13/starpy-1.0.0a13.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fstarpy%2Ffiles%2Fstarpy%2F1.0.0a13%2F&ts=1459000345&use_mirror=nbtelecom
    tar zxvf starpy.tar.gz
    cd starpy-1.0.0a13
    python setup.py install
    
# Python Mysql Library
    apt-get install python-MySQLdb