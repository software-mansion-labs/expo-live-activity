import { PropsWithChildren } from 'react'
import { Text as RNText, type TextProps, type TextStyle } from 'react-native'

interface Props extends Omit<TextProps, 'style'> {
  bold?: boolean
  medium?: boolean
  color?: string
  size?: number
  opacity?: number
  style?: TextStyle
}

export default function OrderItem({
  bold,
  medium,
  color,
  children,
  opacity,
  size = 16,
  style,
  ...props
}: PropsWithChildren<Props>) {
  return (
    <RNText
      {...props}
      style={[
        { minHeight: 22 },
        style,
        { color, fontWeight: bold ? 600 : medium ? 500 : undefined, fontSize: size, opacity },
      ]}
    >
      {children}
    </RNText>
  )
}
