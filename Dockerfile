FROM lambci/lambda:build-python3.7

RUN pip install numpy
ADD ./deploy.sh .
