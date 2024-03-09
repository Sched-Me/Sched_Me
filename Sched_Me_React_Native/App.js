import { StatusBar } from 'expo-status-bar';
import { StyleSheet, View, Button } from 'react-native';
import { useState } from 'react';
import { Cal } from './components/Calendar';
import { Classes } from './components/Classes';
import { Navigation } from './components/Navigation';
import { Sharing } from './components/Sharing';
import { Settings } from './components/Settings';

export default function App() {
  const [selected, setSelected] = useState('');

  return (
    <View style={styles.container}>
      <Cal selected={selected} setSelected={setSelected}/>
      <Classes />
      <Navigation />
      <Sharing />
      <Settings />
      <StatusBar style="auto" />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
