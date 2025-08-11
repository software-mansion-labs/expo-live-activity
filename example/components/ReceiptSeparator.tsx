import { Image } from 'react-native'

export default function ReceiptSeparator() {
  return (
    <Image
      source={require('../assets/receipt-border-segment.png')}
      resizeMode="repeat"
      style={{ width: '100%', height: 5, backgroundColor: 'white' }}
    />
  )
}
