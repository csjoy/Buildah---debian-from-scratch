# Buildah---debian-from-scratch
Building a demo OCI container image from scratch using buildah.

## Manual

### Step 1
Make sure you have buildah and debootstrap installed on your local machine. if not
```
apt update
apt install buildah debootstrap -y
```

### Step 2
Run the following commands
```
buildah from scratch
scratchmount=$(buildah mount working-container)
debootstrap --variant=minbase bookworm $scratchmount
buildah commit working-container bookworm
```

## Automatic
### Step 1
Clone this repo and make the shell script executable.
```
chmod +x debian-from-scratch.sh
```
### Step 2
Run the following command with your preferred image name as argument. The default is 'bookworm'
```
./debian-from-scratch.sh
```
or
```
./debian-from-scratch.sh debian-bookworm
```

<hr>
You now have a OCI image on your local machine. You can manage this image with docker or podman.
