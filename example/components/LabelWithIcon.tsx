import { FC, PropsWithChildren } from 'react'
import { StyleSheet, View } from 'react-native'
import type { SvgProps } from 'react-native-svg'
import Text from './Text'

interface Props {
  Icon: FC<SvgProps>
  color?: string
}

export default function LabelWithIcon({ children, Icon, color }: PropsWithChildren<Props>) {
  return (
    <View style={styles.container}>
      <Icon />
      <Text bold color={color}>
        {children}
      </Text>
    </View>
  )
}

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 10,
    paddingVertical: 20,
  },
})
