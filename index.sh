
#Directory destination
OutFile=./National_Geographic_Image/`date +%Y-%m-%d`.jpeg

if [ ! -f $OutFile ]; then

#Get Description file
descriptionFile=$(curl -s https://www.nationalgeographic.com/photography/photo-of-the-day/_jcr_content/.gallery.json | jq -r '.items[0].altText')

#Get BaseUrl
baseUrl=$(curl -s https://www.nationalgeographic.com/photography/photo-of-the-day/_jcr_content/.gallery.json | jq -r '.items[0].url')

#Get ImageUrl with max resolution
imageUrl=$(curl -s https://www.nationalgeographic.com/photography/photo-of-the-day/_jcr_content/.gallery.json | jq -r '.items[0].sizes."2048"')

#If there are errors in BaseUrl or ImageUrl
if { [ -z "$imageUrl" ] || [ -z "$baseUrl" ]; }; then
	echo "Curl error" 
	exit 3
fi

if { [ "$imageUrl" == "null" ] || [ "$baseUrl" == "null" ]; }; then
	echo "Jq error"
	exit 4
fi

#Create the complete Url
completeUrl=$baseUrl$imageUrl

#Create a file named $OutFile with the image
$(curl $completeUrl -s > $OutFile)

#Adding description metadata
exiftool -Description="$descriptionFile" $OutFile

#Remove file without description
rm $OutFile"_original"
echo "Saved on" $OutFile

fi
 
