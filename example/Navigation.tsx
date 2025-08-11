import { HeaderTitleProps } from '@react-navigation/elements'
import { createStaticNavigation, StaticParamList } from '@react-navigation/native'
import { createNativeStackNavigator } from '@react-navigation/native-stack'
import { Text } from './components'
import { colors } from './constants'
import HomeScreen from './screens/HomeScreen'
import OrderConfirmedScreen from './screens/OrderConfirmedScreen'
import OrderScreen from './screens/OrderScreen'

const headerTitle = ({ children }: HeaderTitleProps) => (
  <Text bold color="white" size={16}>
    {children}
  </Text>
)

const RootStack = createNativeStackNavigator({
  initialRouteName: 'Home',
  screens: {
    Home: {
      screen: HomeScreen,
      options: {
        headerTitle,
        headerStyle: {
          backgroundColor: colors.primary,
        },
        title: 'Review your order',
        headerShadowVisible: false,
      },
    },
    OrderConfirmed: {
      screen: OrderConfirmedScreen,
      options: {
        headerStyle: {
          backgroundColor: 'white',
        },
        title: '',
        headerBackVisible: false,
        headerShadowVisible: false,
      },
    },
    Order: {
      screen: OrderScreen,
      options: {
        headerTitle,
        headerStyle: {
          backgroundColor: colors.primary,
        },
        title: 'Delivery Details',
        headerShadowVisible: false,
      },
    },
  },
})

const Navigation = createStaticNavigation(RootStack)

type RootStackParamList = StaticParamList<typeof RootStack>

declare global {
  namespace ReactNavigation {
    interface RootParamList extends RootStackParamList {}
  }
}

export default Navigation
