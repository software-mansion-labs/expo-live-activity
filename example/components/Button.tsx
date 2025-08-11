import { PropsWithChildren } from 'react'
import { StyleSheet, TouchableOpacity, type TouchableOpacityProps, View } from 'react-native'
import { colors } from '../constants'
import Text from './Text'

interface Props {
  borderless?: boolean
  primary?: boolean
  onPress?: TouchableOpacityProps['onPress']
  style?: TouchableOpacityProps['style']
}

export default function Button({ borderless, children, onPress, primary, style }: PropsWithChildren<Props>) {
  return (
    <TouchableOpacity
      onPress={onPress}
      style={[
        style,
        styles.container,
        { borderWidth: Number(!borderless), backgroundColor: primary ? colors.primary : undefined },
      ]}
    >
      <Text bold={primary} color={primary ? 'white' : 'black'}>
        {children}
      </Text>
    </TouchableOpacity>
  )
}

const styles = StyleSheet.create({
  container: {
    borderColor: colors.border,
    borderRadius: 20,
    alignItems: 'center',
    paddingVertical: 8,
    paddingHorizontal: 20,
  },
})
