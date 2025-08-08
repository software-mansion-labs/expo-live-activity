import { useNavigation } from '@react-navigation/native'
import { Image, StyleSheet, View } from 'react-native'
import MarkerIcon from '../assets/icons/marker.svg'
import DriverIcon from '../assets/icons/driver.svg'
import OrderListImage from '../assets/order-list.svg'
import { colors } from '../constants'
import {
  Button,
  EditableItem,
  LabelWithIcon,
  OrderList,
  OrderView,
  ReceiptSeparator,
  Summary,
  Text,
  ValueWithLabel,
} from '../components'
import { sharedStyles } from '../components/OrderView'
import { useBackButton } from '../hooks'

export default function OrderScreen() {
  const { navigate } = useNavigation()

  useBackButton()

  return (
    <OrderView HeaderImage={OrderListImage}>
      <View style={sharedStyles.main}>
        <Text bold style={sharedStyles.headerText}>
          Your Delivery Is On The Way!
        </Text>
        <Text bold color={colors.primary} size={38} style={styles.counter}>
          35:27
        </Text>
        <View style={styles.info}>
          <Text size={14} opacity={0.6}>
            Order # PP-2478
          </Text>
          <Text size={14} opacity={0.6}>
            Placed Today, 7:23 PM
          </Text>
        </View>
        <OrderList />
        <LabelWithIcon Icon={MarkerIcon}>Delivering To</LabelWithIcon>
        <EditableItem line1="1247 Valencia Street, Apt 4B" line2="San Francisco, CA 94110" readOnly />
        <LabelWithIcon Icon={DriverIcon}>Driver Information</LabelWithIcon>
        <View>
          <ValueWithLabel label="Driver">Marco R.</ValueWithLabel>
          <ValueWithLabel label="Vahicle">Red Honda Civic</ValueWithLabel>
          <ValueWithLabel label="Phone">(415) 555-1234</ValueWithLabel>
        </View>
      </View>
      <ReceiptSeparator />
      <View style={sharedStyles.summary}>
        <Summary />
        <Button primary borderless style={sharedStyles.actionButton} onPress={() => {}}>
          Contact Driver
        </Button>
      </View>
    </OrderView>
  )
}

const styles = StyleSheet.create({
  counter: {
    alignSelf: 'center',
  },
  info: {
    alignSelf: 'center',
    flexDirection: 'row',
    gap: 20,
  },
})
