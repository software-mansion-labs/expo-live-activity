import { PropsWithChildren } from 'react'
import { ScrollView, StyleSheet, View } from 'react-native'
import type { SvgProps } from 'react-native-svg'
import { colors } from '../constants'

interface Props {
  HeaderImage: React.FC<SvgProps>
}

export default function OrderView({ children, HeaderImage }: PropsWithChildren<Props>) {
  return (
    <ScrollView contentContainerStyle={styles.container}>
      <View style={styles.header}>
        <HeaderImage style={styles.headerImage} />
      </View>
      {children}
    </ScrollView>
  )
}

const styles = StyleSheet.create({
  container: {
    backgroundColor: colors.primary,
    fontFamily: 'Onest',
    paddingTop: 60,
  },
  header: {
    backgroundColor: 'white',
    borderTopLeftRadius: 40,
    borderTopRightRadius: 40,
    alignItems: 'center',
    justifyContent: 'center',
    paddingTop: 40,
  },
  headerImage: {
    marginTop: -75,
  },
})

export const sharedStyles = StyleSheet.create({
  main: {
    paddingHorizontal: 20,
    backgroundColor: 'white',
    paddingBottom: 30,
  },
  headerText: {
    width: '60%',
    alignSelf: 'center',
    textAlign: 'center',
    marginVertical: 20,
  },
  tipButtons: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  summary: {
    paddingHorizontal: 20,
    paddingTop: 10,
    paddingBottom: 30,
    backgroundColor: colors.secondary,
  },
  actionButton: {
    marginVertical: 20,
  },
})
