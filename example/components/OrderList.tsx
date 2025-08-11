import { StyleSheet, View } from 'react-native'
import { colors } from '../constants'
import OrderItem from './OrderItem'

export default function OrderList() {
  return (
    <View style={styles.container}>
      <OrderItem
        amount={1}
        name="Pizza Margherita"
        description="Fresh mozzarella, San Marzano tomatoes, basil"
        price={18.99}
      />
      <OrderItem amount={6} name="Garlic Knots" price={6.5} />
      <OrderItem amount={1} name="Diet Coke (20oz)" price={2.99} />
    </View>
  )
}

const styles = StyleSheet.create({
  container: {
    borderBottomColor: colors.border,
    borderBottomWidth: 1,
    gap: 10,
    paddingVertical: 20,
  },
})
