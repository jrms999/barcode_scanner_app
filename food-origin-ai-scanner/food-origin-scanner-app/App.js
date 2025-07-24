import React, { useState } from 'react';
import { View, Text, Button, Image, StyleSheet } from 'react-native';
import * as ImagePicker from 'expo-image-picker';
import axios from 'axios';

export default function App() {
  const [image, setImage] = useState(null);
  const [result, setResult] = useState(null);

  const pickImage = async () => {
    let result = await ImagePicker.launchImageLibraryAsync({
      mediaTypes: ImagePicker.MediaTypeOptions.Images,
      allowsEditing: true,
      quality: 1,
    });

    if (!result.canceled) {
      setImage(result.assets[0].uri);
      scanBarcode(result.assets[0].uri);
    }
  };

  const scanBarcode = async (uri) => {
    const data = new FormData();
    data.append('image', {
      uri,
      name: 'photo.jpg',
      type: 'image/jpg'
    });

    try {
      const response = await axios.post('http://127.0.0.1:5000/lookup', data, {
        headers: { 'Content-Type': 'multipart/form-data' }
      });
      setResult(response.data);
    } catch (error) {
      console.error(error);
    }
  };

  return (
    <View style={styles.container}>
      <Button title="Pick an image of a barcode" onPress={pickImage} />
      {image && <Image source={{ uri: image }} style={styles.image} />}
      {result && (
        <View>
          <Text>Country: {result.country}</Text>
          <Text>Continent: {result.continent}</Text>
        </View>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  image: {
    width: 200,
    height: 200,
    margin: 10,
  },
});