import { StyleSheet, View } from 'react-native'
import ChevronRightImage from '../assets/icons/chevron-right.svg'
import Text from './Text'

interface Props {
  line1: string
  line2: string
  readOnly?: boolean
}

export default function EditableItem({ line1, line2, readOnly }: Props) {
  return (
    <View style={styles.container}>
      <View style={styles.left}>
        <Text>{line1}</Text>
        <Text>{line2}</Text>
      </View>
      {!readOnly && <ChevronRightImage />}
    </View>
  )
}

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
  },
  left: {
    flex: 1,
  },
})
