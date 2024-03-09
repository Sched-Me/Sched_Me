import { Calendar } from 'react-native-calendars';
import { useState } from 'react';
import { ScrollView, StyleSheet, Text, View, Dimensions, TouchableOpacity, Button, Modal, TextInput } from 'react-native';
import DateTimePicker from '@react-native-community/datetimepicker';
import { Checkbox } from 'react-native-paper';

export function Cal({ selected, setSelected }) {
    const [events, setEvents] = useState({});
    const window = Dimensions.get('window');
    const screenWidth = window.width;

    const addEvents = (date, eventName, startTime, endTime, loc, isAllDay) => {
        setEvents(prevState => ({
            ...prevState,
            [date]: [
                ...(prevState[date] || []),
                {
                    name: eventName,
                    start: startTime,
                    finish: endTime,
                    location: loc,
                    allDay: isAllDay
                },
            ],
        }));
    };
    
    return (
      <View style={styles.container}> 
        <Calendar
          style={{
            marginTop: 50,
            width: screenWidth,
          }}
          onDayPress={day => {
            setSelected(day.dateString);
            // console.log(day.dateString)
            // addEvents(day.dateString, 'Event Name', day.dateString);
          }}
          markedDates={{
            [selected]: {selected: true, disableTouchEvent: true, selectedDotColor: 'orange'}
          }}
        />
        <AddButton addEvents={addEvents}/>
        <ScrollView style={{height: 350}}>
            {events[selected] && events[selected].map((detail, index) => (
                <EventCard 
                    key={`${selected}-${index}`}
                    name={detail.name ? detail.name : 'Event Name'} 
                    start={detail.start ? detail.start : ''} 
                    finish={detail.finish ? detail.finish : ''}
                    location={detail.location ? detail.location : ''}
                    allDay={detail.allDay ? detail.allDay : false}
                />
            ))}
        </ScrollView>
      </View>
    );
}

function AddButton({ addEvents }) {
    const [modalVisible, setModalVisible] = useState(false);
    const [eventName, setEventName] = useState('');
    const [location, setLocation] = useState('');
    const [notes, setNotes] = useState('');
    const [startDate, setStartDate] = useState(new Date());
    const [endDate, setEndDate] = useState(new Date());
    const [isAllDay, setIsAllDay] = useState(false);
    const [dateOrTime, setDateOrTime] = useState('datetime');
    const [isRecurring, setIsRecurring] = useState(false); // FIXME: finish this
    const [isClass, setIsClass] = useState(false); // FIXME: finish this

    const difference = endDate.getTime() - startDate.getTime();
    const daysApart = Math.round(difference / (1000 * 60 * 60 * 24));

    const handleMultipleDays = () => {
        setModalVisible(!modalVisible);
        const oneDay = 24 * 60 * 60 * 1000;
        let newDate = new Date(startDate.getTime() - oneDay);

        for(let i = daysApart; i > 0; i--) {
            addEvents(formatDate(newDate), eventName, formatTime(startDate), formatTime(endDate), location, isAllDay);
            console.log(newDate);
            newDate = new Date(newDate.getTime() + oneDay);
        }
        addEvents(formatDate(newDate), eventName, formatTime(startDate), formatTime(endDate), location, isAllDay);

        setEventName('');
        setLocation('');
        setNotes('');
        setStartDate(new Date());
        setEndDate(new Date());
        setIsAllDay(false);
        setDateOrTime('datetime');
        setIsRecurring(false);    
    };

    const renderComponent = () => {
        if (daysApart < 0) {
          return <Text style={{color: "grey", fontSize: 18}}>Submit</Text>;
        } 
        else if (daysApart > 0) {
            return (
                <Button
                  title="Submit"
                  onPress={handleMultipleDays}
                />
            );        
        } 
        else {
          return (
            <Button
              title="Submit"
              onPress={handleSubmit}
            />
          );
        }
      }
    
    const handleClassClick = () => {

    };

    const handleRecurClick = () => {

    };

    const formatDate = (date) => {
        return date.toISOString().split('T')[0];
    };

    const formatTime = (date) => {
        return date.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' });
    };

    const handleClick = () => {
        if(isAllDay === true) {
            setDateOrTime('datetime');
        }
        else {
            setDateOrTime('date');
        }
    };

    const handleSubmit = () => {
        setModalVisible(!modalVisible);
        const oneDay = 24 * 60 * 60 * 1000;
        const newDate = new Date(startDate.getTime() - oneDay);
        addEvents(formatDate(newDate), eventName, formatTime(startDate), formatTime(endDate), location, isAllDay);
        setEventName('');
        setLocation('');
        setNotes('');
        setStartDate(new Date());
        setEndDate(new Date());
        setIsAllDay(false);
        setDateOrTime('datetime');
        setIsRecurring(false);
    };

    return (
        <View style={styles.centeredView}>
            <Button
                title="Add Courses/Events"
                onPress={() => setModalVisible(true)}
            />
            <Modal
                animationType="slide"
                transparent={true}
                visible={modalVisible}
                onRequestClose={() => {
                Alert.alert("Modal has been closed.");
                setModalVisible(!modalVisible);
                }}
            >
                <View style={styles.centeredView}>
                <View style={styles.modalView}>
                    <Text style={{textAlign: 'center', marginBottom: 20, fontSize: 20}}>{eventName === '' ? 'Name' : eventName}</Text>
                    <Text style={styles.modalText}>Enter Event Information Below</Text>
                    <TextInput
                        style={styles.input}
                        onChangeText={setEventName}
                        value={eventName}
                        placeholder="Event Name"
                        keyboardType="default"
                    />
                    <TextInput
                        style={styles.input}
                        onChangeText={setLocation}
                        value={location}
                        placeholder="Location"
                        keyboardType="default"
                    />
                    <View style={{flexDirection: 'row', padding: 5}}>
                        <Text style={{marginTop: 10, paddingRight: 10}}>Is the event all day?</Text>
                        <Checkbox
                            status={isAllDay ? 'checked' : 'unchecked'}
                            onPress={() => {
                                setIsAllDay(!isAllDay);
                                handleClick();
                            }}
                            borderWidth='1'
                            borderRadius='1'
                        />
                    </View>
                    <Text style={{fontSize: 20}}>Start</Text>
                    <DateTimePicker 
                        value={startDate}
                        mode={dateOrTime}
                        display="default"
                        onChange={(event, selectedDate) => {
                            const currentDate = selectedDate || startDate;
                            setStartDate(currentDate);
                        }}
                    />
                    <Text style={{fontSize: 20, paddingTop: 10}}>Finish</Text>
                    <DateTimePicker
                        value={endDate}
                        mode={dateOrTime}
                        display="default"
                        onChange={(event, selectedDate) => {
                            const currentDate = selectedDate || endDate;
                            setEndDate(currentDate);
                        }}
                    />    
                    <View style={{flexDirection: 'row', padding: 5}}>
                        <Text style={{marginTop: 10, paddingRight: 10}}>Is the event recurring?</Text>
                        <Checkbox
                            status={isRecurring ? 'checked' : 'unchecked'}
                            onPress={() => {
                                setIsRecurring(!isRecurring);
                                handleRecurClick();
                            }}
                            borderWidth='1'
                            borderRadius='1'
                        />
                    </View>  
                    <View style={{flexDirection: 'row', padding: 5}}>
                        <Text style={{marginTop: 10, paddingRight: 10}}>Is the event a class?</Text>
                        <Checkbox
                            status={isClass ? 'checked' : 'unchecked'}
                            onPress={() => {
                                setIsClass(!isClass);
                                handleClassClick();
                            }}
                            borderWidth='1'
                            borderRadius='1'
                        />
                    </View>
                    <TextInput
                        style={styles.input}
                        onChangeText={setNotes}
                        value={notes}
                        placeholder="Notes"
                        keyboardType="default"
                    />       
                    {/* {daysApart < 0 ? 
                        <Text style={{color: "grey", fontSize: 18}}>Submit</Text>
                    :
                        <Button
                            title="Submit"
                            onPress={handleSubmit}
                        />
                    } */}
                    {renderComponent()}
                </View>
                </View>
            </Modal>
        </View>
    );
}

function EventCard({ name, start, finish, location, allDay }) {
    const handleClick = () => {
        console.log("pressed");
    };

    return (
        <TouchableOpacity onPress={handleClick}>
            <View style={styles.eventCard}>
                <View style={{flexDirection: 'row', justifyContent: 'space-between'}}> 
                    <Text style={[styles.eventText, {flex: 1}]}>{name}</Text>
                    {allDay ? <Text>All Day</Text> : <Text style={[styles.eventTime, {flex: 1}]}>{start}</Text>}
                </View>
                <View style={{flexDirection: 'row', justifyContent: 'space-between'}}>
                    <Text style={{color: "grey"}}>{location}</Text> 
                    {allDay ? "" : <Text style={styles.eventTime}>{finish}</Text>}
                </View>
            </View>
        </TouchableOpacity>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        marginBottom: 100,
    },
    eventCard: {
        borderRadius: 5,
        borderColor: 'black',
        backgroundColor: '#72a7fc',
        marginHorizontal: 10,
        marginTop: 5,
        padding: 10,
    },
    eventTime: {
        textAlign: 'right',
    },
    centeredView: {
        flex: 1,
        justifyContent: "center",
        alignItems: "center",
    },
    modalView: {
        margin: 20,
        backgroundColor: "white",
        borderRadius: 20,
        padding: 35,
        alignItems: "center",
        shadowColor: "#000",
        shadowOffset: {
          width: 0,
          height: 2
        },
        shadowOpacity: 0.25,
        shadowRadius: 4,
        elevation: 5
    },
    modalText: {
        marginBottom: 15,
        textAlign: "center"
    },
    input : {
        margin: 10,
    }
});
