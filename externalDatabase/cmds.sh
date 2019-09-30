create database teamcity collate utf8_bin;
create user teamcity identified by 'password';
grant all privileges on teamcity.* to teamcity;
grant process on *.* to teamcity;

kubectl delete po teamcity;
kubectl delete deployment,svc mysql;
kubectl delete pvc mysql-pv-claim;
kubectl delete pv mysql-pv-volume;


kubectl apply -f mysql-pv.yaml;
kubectl apply -f mysql-deployment.yaml;
kubectl apply -f teamcity.yaml;

#docker stuff
docker build -t duffney/teamcity-server .
docker run -it -w /sln -v $PWD:/sln ubuntu