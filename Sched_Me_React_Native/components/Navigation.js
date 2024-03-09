import React from 'react';
import { View, TouchableOpacity, Text, StyleSheet } from 'react-native';
import Icon from 'react-native-vector-icons/MaterialIcons';

export function Navigation({ setSelectedPage}) {
    return (
        <View style={styles.bar}>
            <TouchableOpacity style={styles.nav} onPress={() => setSelectedPage("Calendar")}>
                <View style={styles.iconContainer}>
                    <Icon name="calendar-today" size={20} color="white" />
                    <Text style={styles.iconText}>Calendar</Text>
                </View>
            </TouchableOpacity>
            <TouchableOpacity style={styles.nav} onPress={() => setSelectedPage("Classes")}>
                <View style={styles.iconContainer}>
                    <Icon name="class" size={20} color="white" />
                    <Text style={styles.iconText}>Classes</Text>
                </View>
            </TouchableOpacity>
            <TouchableOpacity style={styles.nav} onPress={() => setSelectedPage("Sharing")}>
                <View style={styles.iconContainer}>
                    <Icon name="share" size={20} color="white" />
                    <Text style={styles.iconText}>Sharing</Text>
                </View>
            </TouchableOpacity>
            <TouchableOpacity style={styles.nav} onPress={() => setSelectedPage("Settings")}>
                <View style={styles.iconContainer}>
                    <Icon name="settings" size={20} color="white" />
                    <Text style={styles.iconText}>Settings</Text>
                </View>
            </TouchableOpacity>
        </View>
    );
}

const styles = StyleSheet.create({
    nav: {
        borderRadius: 100,
        flex: 1,
        alignItems: 'center',
        justifyContent: 'center',
        padding: 10,
    },
    bar: {
        borderRadius: 100,
        flexDirection: 'row',
        marginBottom: 20,
        backgroundColor: '#72a7fc',
        margin: 20,
    },
    iconContainer: {
        alignItems: 'center', 
    },
    iconText: {
        paddingTop: 2,
        color: 'white', 
        fontSize: 10,
    },
});
