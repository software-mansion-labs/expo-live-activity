import { StyleSheet, View } from 'react-native'
import Text from './Text'

interface Props {
  amount: number
  name: string
  price: number

  description?: string
}

export default function OrderItem({ amount, name, description, price }: Props) {
  return (
    <View style={styles.container}>
      <Text style={styles.amount}>{amount}x</Text>
      <View style={styles.product}>
        <Text medium>{name}</Text>
        {description && (
          <Text size={14} opacity={0.6}>
            {description}
          </Text>
        )}
      </View>
      <Text>${price}</Text>
    </View>
  )
}

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  amount: {
    width: 30,
  },
  product: {
    flex: 1,
    marginRight: 20,
  },
})
