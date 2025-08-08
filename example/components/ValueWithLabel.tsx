import { PropsWithChildren } from 'react'
import { View } from 'react-native'
import Text from './Text'

interface Props {
  label: string
}

export default function ValueWithLabel({ children, label }: PropsWithChildren<Props>) {
  return (
    <View>
      <Text bold>{label}:</Text>
      <Text>{children}</Text>
    </View>
  )
}
