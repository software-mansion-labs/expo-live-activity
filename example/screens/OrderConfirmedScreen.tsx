import { StyleSheet, View } from 'react-native'
import { useNavigation } from '@react-navigation/native'
import OrderConfirmedImage from '../assets/order-confirmed.svg'
import { Button, Text } from '../components'

export default function OrderConfirmedScreen() {
  const { navigate } = useNavigation()

  return (
    <View style={styles.container}>
      <View style={styles.main}>
        <OrderConfirmedImage />
        <Text bold style={styles.orderConfirmedTitle}>
          Order confirmed
        </Text>
        <Text style={styles.orderConfirmedText}>We're getting everything ready and it will be on the way soon!</Text>
      </View>
      <Button primary onPress={() => navigate('Order')}>
        View Your Order
      </Button>
    </View>
  )
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: 'white',
    paddingHorizontal: 20,
    paddingVertical: 40,
  },
  main: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  orderConfirmedTitle: {
    marginVertical: 20,
  },
  orderConfirmedText: {
    textAlign: 'center',
    marginHorizontal: 20,
  },
})
