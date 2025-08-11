import SummaryItem from './SummaryItem'
import Text from './Text'

export default function Summary() {
  return (
    <>
      <Text bold style={{ paddingVertical: 20 }}>
        Summary
      </Text>
      <SummaryItem name="Subtotal" price={28.48} />
      <SummaryItem name="Tax" price={2.56} />
      <SummaryItem name="Tip for the driver" price={2.85} />
      <SummaryItem name="Total" price={33.89} bold />
    </>
  )
}
