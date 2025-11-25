import { ScrollView, Text, View } from 'react-native';
import Driver from "expo-headless-browser";
import React, { useEffect, useState } from "react";

export default function App() {
  const [level, setLevel] = useState<number | null>(null);
  const [info, setInfo] = useState<{
    brand: string;
    model: string;
    os: string;
    version: string;
  } | null>(null);

  useEffect(() => {
    (async () => {
      const driver = new Driver();
      console.log('driver', driver)
      await driver.get("https://apeira.it")
      const titleEl = await driver.getElementsByCss(".text-cozy-copper");
      try {
        await driver.get("https://google.it")
        console.log('title', await driver.getTitle());
      } catch(err) {console.log('err',err)}
    })();
  }, []);

  return (
    <ScrollView style={styles.container}>
      <Text style={styles.header}>ExpoNativeCalls Demo</Text>

    </ScrollView>
  );
}


const styles = {
  header: {
    fontSize: 30,
    margin: 20,
    marginTop: 100,
    textAlign: 'center' as const,
  },
  groupHeader: {
    fontSize: 20,
    marginBottom: 10,
  },
  group: {
    margin: 20,
    backgroundColor: '#fff',
    borderRadius: 10,
    padding: 20,
  },
  container: {
    flex: 1,
    backgroundColor: '#eee',
  },
};