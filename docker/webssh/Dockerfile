from python:slim

run pip3 install webssh -i https://mirrors.aliyun.com/pypi/simple/

expose 8080
CMD ["wssh", "--address=0.0.0.0", "--port=8080", "--xsrf=False", "--origin=*", "--debug", "--wpintvl=20"]