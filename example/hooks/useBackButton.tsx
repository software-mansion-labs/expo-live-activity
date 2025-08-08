import { useNavigation } from '@react-navigation/native'
import { NativeStackHeaderLeftProps } from '@react-navigation/native-stack'
import { useEffect } from 'react'
import BackButtonImage from '../assets/back-button.svg'

export default function useBackButton() {
  const { setOptions, goBack } = useNavigation()

  useEffect(() => {
    setOptions({
      headerLeft: ({ canGoBack }: NativeStackHeaderLeftProps) => (
        <BackButtonImage height={32} onPress={canGoBack ? goBack : undefined} />
      ),
    })
  })
}
