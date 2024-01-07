projectDirectory=ennovify
containerName=$projectDirectory
cd $projectDirectory
git pull origin master
headHash=$(git rev-parse HEAD)
imageName=i_$containerName_$headHash
podman build -t $imageName .
podman stop $containerName
podman rm $containerName
podman run -dit --name $containerName --restart unless-stopped --network minhazul-net $imageName