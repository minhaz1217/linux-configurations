sudo docker build -t i_portfolio .

sudo docker run -dit --name portfolio --network minhazul-net --restart always i_portfolio