import { View, Text, StyleSheet, ScrollView, TouchableOpacity } from 'react-native';

export function Classes({ classes }) {
    return (
        <View style={{ flex: 1 }}>
            <ScrollView style={{ flex: 1, paddingTop: 50 }}>
                {classes.map((detail, index) => (
                    index !== 0 && (<ClassCard 
                        key={`${index}`}
                        name={detail.name ? detail.name : 'Event Name'} 
                        location={detail.location ? detail.location : ''}
                    />)
                ))}
            </ScrollView>
        </View>
    );
}

function ClassCard({ name, location }) {
    const handleClick = () => {
        console.log("pressed");
    };

    return (
        <TouchableOpacity onPress={handleClick}>
            <View style={styles.classCard}>
                <Text style={{fontSize: 20}}>{name}</Text>
                <Text style={{fontSize: 18}}>{location}</Text>
            </View>
        </TouchableOpacity>
    );
}

const styles = StyleSheet.create({
    classCard: {
        borderRadius: 5,
        borderColor: 'black',
        backgroundColor: '#72a7fc',
        // marginHorizontal: 10,
        marginTop: 5,
        padding: 10,
    },
});