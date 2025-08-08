import { StyleSheet, View } from 'react-native'
import Text from './Text'

interface Props {
  name: string
  price: number
  bold?: boolean
}

export default function SummaryItem({ name, price, bold }: Props) {
  return (
    <View style={styles.container}>
      <View style={styles.name}>
        <Text bold={bold}>{name}</Text>
      </View>
      <Text bold={bold}>${price}</Text>
    </View>
  )
}

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    paddingVertical: 6,
  },
  name: {
    flex: 1,
  },
})
