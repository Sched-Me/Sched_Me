import { StatusBar } from 'expo-status-bar';
import { StyleSheet, View } from 'react-native';
import { useState } from 'react';
import { Cal } from './components/Calendar';
import { Classes } from './components/Classes';
import { Navigation } from './components/Navigation';
import { Sharing } from './components/Sharing';
import { Settings } from './components/Settings';

export default function App() {
  const [classes, setClasses] = useState([{}]);
  const [selectedPage, setSelectedPage] = useState('Calendar');

  const Navigate = () => {
    if(selectedPage === "Calendar") {
      return <Cal setClasses={setClasses} />
    }
    else if(selectedPage === "Classes") {
      return <Classes classes={classes} />
    }
    else if(selectedPage === "Sharing") {
      return <Sharing />
    }
    else {
      return <Settings />
    }
  };

  return (
    <View style={styles.container}>
      {/* <Cal setClasses={setClasses} /> */}
      <Navigate />
      <Navigation setSelectedPage={setSelectedPage}/>
      <StatusBar style="auto" />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
});
