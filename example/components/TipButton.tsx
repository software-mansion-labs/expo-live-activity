import { PropsWithChildren } from 'react'
import Button from './Button'

interface Props {
  selected?: boolean
}

export default function TipButton({ children, selected }: PropsWithChildren<Props>) {
  return <Button primary={selected}>{children}</Button>
}
