import { useNavigation } from '@react-navigation/native'
import { View } from 'react-native'
import OrderListImage from '../assets/order-list.svg'
import MarkerIcon from '../assets/icons/marker.svg'
import AddIcon from '../assets/icons/add.svg'
import TipIcon from '../assets/icons/tip.svg'
import PaymentCardIcon from '../assets/icons/payment-card.svg'
import {
  Button,
  EditableItem,
  LabelWithIcon,
  OrderList,
  OrderView,
  ReceiptSeparator,
  Summary,
  Text,
  TipButton,
} from '../components'
import { sharedStyles } from '../components/OrderView'
import { colors } from '../constants'
import { useBackButton, useLiveActivity } from '../hooks'

export default function HomeScreen() {
  const { navigate, setOptions, goBack } = useNavigation()
  const { start: startLiveActivity } = useLiveActivity()

  useBackButton()

  return (
    <OrderView HeaderImage={OrderListImage}>
      <View style={sharedStyles.main}>
        <Text bold style={sharedStyles.headerText}>
          Please review your order before we send it your way
        </Text>
        <OrderList />
        <LabelWithIcon Icon={MarkerIcon}>Delivering To</LabelWithIcon>
        <EditableItem line1="1247 Valencia Street, Apt 4B" line2="San Francisco, CA 94110" />
        <LabelWithIcon Icon={AddIcon} color={colors.primary}>
          Add Delivery Instructions
        </LabelWithIcon>
        <LabelWithIcon Icon={TipIcon}>Tip for The Driver</LabelWithIcon>
        <View style={sharedStyles.tipButtons}>
          <TipButton>0%</TipButton>
          <TipButton>5%</TipButton>
          <TipButton selected>10%</TipButton>
          <TipButton>15%</TipButton>
        </View>
        <LabelWithIcon Icon={PaymentCardIcon}>Payment Method</LabelWithIcon>
        <EditableItem line1="Credit Card" line2="**** 1234" />
      </View>
      <ReceiptSeparator />
      <View style={sharedStyles.summary}>
        <Text bold style={{ paddingVertical: 20 }}>
          Summary
        </Text>
        <Summary />
        <Button
          primary
          borderless
          style={sharedStyles.actionButton}
          onPress={() => {
            startLiveActivity()
            navigate('OrderConfirmed')
          }}
        >
          Place YourOrder ($33.89)
        </Button>
      </View>
    </OrderView>
  )
}
