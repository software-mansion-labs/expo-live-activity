import RNDateTimePicker from '@react-native-community/datetimepicker'
import type {
  ImageAlign,
  ImageContentFit,
  ImagePosition,
  LiveActivityConfig,
  LiveActivityState,
} from 'expo-live-activity'
import * as LiveActivity from 'expo-live-activity'
import { useCallback, useState } from 'react'
import {
  ActionSheetIOS,
  Button,
  Keyboard,
  Platform,
  Pressable,
  ScrollView,
  StyleSheet,
  Switch,
  Text,
  TextInput,
  View,
} from 'react-native'

const dynamicIslandImageName = 'logo-island'
const toggle = (previousState: boolean) => !previousState
const toNum = (v: string) => (v === '' ? undefined : parseInt(v, 10))
const DIMENSION_INPUT_REGEX = /^\d*(?:\.\d*)?%?$/

export default function CreateLiveActivityScreen() {
  const [activityId, setActivityID] = useState<string | null>()
  const [title, onChangeTitle] = useState('Title')
  const [subtitle, onChangeSubtitle] = useState('This is a subtitle')
  const [imageName, onChangeImageName] = useState('logo')
  const [date, setDate] = useState(new Date(Date.now() + 5 * 60 * 1000))
  const [isTimerTypeDigital, setTimerTypeDigital] = useState(false)
  const [progress, setProgress] = useState('0.5')
  const [passSubtitle, setPassSubtitle] = useState(true)
  const [passImage, setPassImage] = useState(true)
  const [passDate, setPassDate] = useState(false)
  const [passProgress, setPassProgress] = useState(false)
  const [passElapsedTimer, setPassElapsedTimer] = useState(false)
  const [elapsedTimerMinutesAgo, setElapsedTimerMinutesAgo] = useState('5')
  const [imageWidth, setImageWidth] = useState('')
  const [imageHeight, setImageHeight] = useState('')
  const [smallImageName, onChangeSmallImageName] = useState('')
  const [smallImageWidth, setSmallImageWidth] = useState('')
  const [smallImageHeight, setSmallImageHeight] = useState('')
  const [imagePosition, setImagePosition] = useState<ImagePosition>('right')
  const [imageAlign, setImageAlign] = useState<ImageAlign>('center')
  const [contentFit, setContentFit] = useState<ImageContentFit>('contain')
  const [showPaddingDetails, setShowPaddingDetails] = useState(false)
  const [paddingSingle, setPaddingSingle] = useState('')
  const [paddingTop, setPaddingTop] = useState('')
  const [paddingBottom, setPaddingBottom] = useState('')
  const [paddingLeft, setPaddingLeft] = useState('')
  const [paddingRight, setPaddingRight] = useState('')
  const [paddingVertical, setPaddingVertical] = useState('')
  const [paddingHorizontal, setPaddingHorizontal] = useState('')
  const [currentStep, setCurrentStep] = useState('')
  const [totalSteps, setTotalSteps] = useState('')
  const [passStepProgress, setPassStepProgress] = useState(false)
  const [segmentActiveColor, setSegmentActiveColor] = useState('#22C55E')
  const [segmentInactiveColor, setSegmentInactiveColor] = useState('#E5E7EB')

  const onChangeProgress = useCallback(
    (text: string) => {
      // Allow only numbers and dot
      if (/^\d*\.?\d*$/.test(text)) {
        // Allow only one dot or comma
        const dotCount = (text.match(/\./g) || []).length
        if (dotCount <= 1) {
          // Allow only numbers between 0 and 1
          const number = parseFloat(text)
          if (number >= 0 && number <= 1) {
            setProgress(text)
          } else if (text === '') {
            setProgress('')
          }
        }
      }
    },
    [setProgress]
  )

  const activityIdState = activityId ? `Activity ID: ${activityId}` : 'No active activity'
  console.log(activityIdState)

  const onChangeNumeric = useCallback((text: string, setter: (val: string) => void) => {
    if (/^\d*$/.test(text)) setter(text)
  }, [])

  const onChangeDimensionText = useCallback((text: string, setter: (val: string) => void) => {
    if (DIMENSION_INPUT_REGEX.test(text)) {
      const dotCount = text.match(/\./g)?.length ?? 0
      if (dotCount <= 1) setter(text)
    }
  }, [])

  const onChangeImageWidthText = useCallback(
    (text: string) => onChangeDimensionText(text, setImageWidth),
    [onChangeDimensionText]
  )
  const onChangeImageHeightText = useCallback(
    (text: string) => onChangeDimensionText(text, setImageHeight),
    [onChangeDimensionText]
  )
  const onChangeSmallImageWidthText = useCallback(
    (text: string) => onChangeDimensionText(text, setSmallImageWidth),
    [onChangeDimensionText]
  )
  const onChangeSmallImageHeightText = useCallback(
    (text: string) => onChangeDimensionText(text, setSmallImageHeight),
    [onChangeDimensionText]
  )

  const computeImageSize = useCallback((wRaw: string, hRaw: string): LiveActivityConfig['imageSize'] => {
    const w = wRaw.trim()
    const h = hRaw.trim()
    if (w === '' && h === '') return undefined

    const parseDim = (raw: string) => {
      if (raw === '') return undefined
      if (/^\d+(?:\.\d+)?%$/.test(raw)) return raw as `${number}%`
      const n = parseInt(raw, 10)
      return isNaN(n) ? undefined : n
    }

    return { width: parseDim(w), height: parseDim(h) }
  }, [])

  const computePadding = useCallback(() => {
    if (!showPaddingDetails) {
      if (paddingSingle !== '') {
        return parseInt(paddingSingle, 10)
      }
      return undefined
    }

    const obj = {
      top: toNum(paddingTop),
      bottom: toNum(paddingBottom),
      left: toNum(paddingLeft),
      right: toNum(paddingRight),
      vertical: toNum(paddingVertical),
      horizontal: toNum(paddingHorizontal),
    }
    const allUndefined = Object.values(obj).every((v) => v === undefined)
    return allUndefined ? undefined : obj
  }, [
    showPaddingDetails,
    paddingSingle,
    paddingTop,
    paddingBottom,
    paddingLeft,
    paddingRight,
    paddingVertical,
    paddingHorizontal,
  ])

  const computeProgressBar = (): LiveActivityState['progressBar'] => {
    if (passStepProgress) {
      return {
        currentStep: toNum(currentStep),
        totalSteps: toNum(totalSteps),
      }
    }

    if (passDate) {
      return { date: date.getTime() }
    }

    if (passElapsedTimer) {
      return {
        elapsedTimer: {
          startDate: Date.now() - (parseInt(elapsedTimerMinutesAgo, 10) || 5) * 60 * 1000,
        },
      }
    }

    if (passProgress) {
      const value = parseFloat(progress)
      return Number.isFinite(value) ? { progress: value } : undefined
    }

    return undefined
  }

  const startActivity = () => {
    Keyboard.dismiss()
    const progressState = computeProgressBar()

    const state: LiveActivityState = {
      title,
      subtitle: passSubtitle ? subtitle : undefined,
      progressBar: progressState,
      imageName: passImage ? imageName : undefined,
      dynamicIslandImageName,
      smallImageName: smallImageName.trim() !== '' ? smallImageName : undefined,
    }

    try {
      const id = LiveActivity.startActivity(state, {
        ...baseActivityConfig,
        timerType: isTimerTypeDigital ? 'digital' : 'circular',
        imageSize: computeImageSize(imageWidth, imageHeight),
        smallImageSize: computeImageSize(smallImageWidth, smallImageHeight),
        imagePosition,
        imageAlign,
        contentFit,
        padding: computePadding(),
        progressSegmentActiveColor: passStepProgress ? segmentActiveColor : undefined,
        progressSegmentInactiveColor: passStepProgress ? segmentInactiveColor : undefined,
      })
      if (id) setActivityID(id)
    } catch (e) {
      console.error('Starting activity failed! ' + e)
    }
  }

  const stopActivity = () => {
    const state: LiveActivityState = {
      title,
      subtitle,
      progressBar: {
        progress: 1,
      },
      imageName,
      dynamicIslandImageName,
      smallImageName: smallImageName.trim() !== '' ? smallImageName : undefined,
    }
    try {
      activityId && LiveActivity.stopActivity(activityId, state)
      setActivityID(null)
    } catch (e) {
      console.error('Stopping activity failed! ' + e)
    }
  }

  const updateActivity = () => {
    const progressState = computeProgressBar()

    const state: LiveActivityState = {
      title,
      subtitle: passSubtitle ? subtitle : undefined,
      progressBar: progressState,
      imageName: passImage ? imageName : undefined,
      dynamicIslandImageName,
      smallImageName: smallImageName.trim() !== '' ? smallImageName : undefined,
    }
    try {
      activityId && LiveActivity.updateActivity(activityId, state)
    } catch (e) {
      console.error('Updating activity failed! ' + e)
    }
  }

  return (
    <ScrollView style={styles.scroll}>
      <View style={styles.container}>
        <Text testID="input-title-label" style={styles.label}>
          Set Live Activity title:
        </Text>
        <TextInput style={styles.input} onChangeText={onChangeTitle} placeholder="Live activity title" value={title} />
        <View style={styles.labelWithSwitch}>
          <Text testID="input-subtitle-label" style={styles.label}>
            Set Live Activity subtitle:
          </Text>
          <Switch onValueChange={() => setPassSubtitle(toggle)} value={passSubtitle} />
        </View>
        <TextInput
          style={passSubtitle ? styles.input : styles.disabledInput}
          onChangeText={onChangeSubtitle}
          placeholder="Live activity title"
          value={subtitle}
          editable={passSubtitle}
        />
        <View style={styles.labelWithSwitch}>
          <Text testID="input-image-name-label" style={styles.label}>
            Set Live Activity image:
          </Text>
          <Switch onValueChange={() => setPassImage(toggle)} value={passImage} />
        </View>
        <TextInput
          style={passImage ? styles.input : styles.disabledInput}
          onChangeText={onChangeImageName}
          autoCapitalize="none"
          placeholder="Live activity image"
          value={imageName}
          editable={passImage}
        />
        <View style={styles.labelWithSwitch}>
          <Text style={styles.label} testID={'input-image-width-label'}>
            Image width (pt or %):
          </Text>
        </View>
        <TextInput
          style={passImage ? styles.input : styles.disabledInput}
          onChangeText={onChangeImageWidthText}
          keyboardType="default"
          autoCapitalize="none"
          testID="input-image-width"
          placeholder="e.g. 80 or 50% or empty (default 64pt)"
          value={imageWidth}
          editable={passImage}
        />
        <View style={styles.labelWithSwitch}>
          <Text style={styles.label} testID="input-image-height-label">
            Image height (pt or %):
          </Text>
        </View>
        <TextInput
          style={passImage ? styles.input : styles.disabledInput}
          onChangeText={onChangeImageHeightText}
          keyboardType="default"
          autoCapitalize="none"
          testID="input-image-height"
          placeholder="e.g. 80 or 50% or empty (default 64pt)"
          value={imageHeight}
          editable={passImage}
        />
        <View style={styles.labelWithSwitch}>
          <Text style={styles.label}>Small view image (Apple Watch / CarPlay):</Text>
        </View>
        <TextInput
          style={passImage ? styles.input : styles.disabledInput}
          onChangeText={onChangeSmallImageName}
          autoCapitalize="none"
          placeholder="Small view image (optional)"
          value={smallImageName}
          editable={passImage}
        />
        <View style={styles.labelWithSwitch}>
          <Text style={styles.label}>Small view image width (pt or %):</Text>
        </View>
        <TextInput
          style={passImage ? styles.input : styles.disabledInput}
          onChangeText={onChangeSmallImageWidthText}
          keyboardType="default"
          autoCapitalize="none"
          placeholder="e.g. 20 or 30% or empty"
          value={smallImageWidth}
          editable={passImage}
        />
        <View style={styles.labelWithSwitch}>
          <Text style={styles.label}>Small view image height (pt or %):</Text>
        </View>
        <TextInput
          style={passImage ? styles.input : styles.disabledInput}
          onChangeText={onChangeSmallImageHeightText}
          keyboardType="default"
          autoCapitalize="none"
          placeholder="e.g. 20 or 30% or empty"
          value={smallImageHeight}
          editable={passImage}
        />
        <View style={styles.labelWithSwitch}>
          <Text style={styles.label}>Image position:</Text>
        </View>
        <Dropdown
          value={imagePosition}
          onChange={(v) => setImagePosition(v as ImagePosition)}
          disabled={!passImage}
          options={[
            { label: 'Left', value: 'left' },
            { label: 'Right', value: 'right' },
            { label: 'Left (stretch)', value: 'leftStretch' },
            { label: 'Right (stretch)', value: 'rightStretch' },
          ]}
        />

        <View style={styles.labelWithSwitch}>
          <Text style={styles.label}>Image vertical align:</Text>
        </View>
        <Dropdown
          value={imageAlign}
          onChange={(v) => setImageAlign(v as 'top' | 'center' | 'bottom')}
          disabled={!passImage}
          options={[
            { label: 'Top', value: 'top' },
            { label: 'Center', value: 'center' },
            { label: 'Bottom', value: 'bottom' },
          ]}
        />

        <View style={styles.labelWithSwitch}>
          <Text style={styles.label}>Image contentFit:</Text>
        </View>
        <Dropdown
          value={contentFit}
          onChange={(v) => setContentFit(v as ImageContentFit)}
          testID="dropdown-content-fit"
          disabled={!passImage}
          options={[
            { label: 'Cover', value: 'cover' },
            { label: 'Contain', value: 'contain' },
            { label: 'Fill', value: 'fill' },
            { label: 'None', value: 'none' },
            { label: 'Scale Down', value: 'scale-down' },
          ]}
        />

        <View style={styles.labelWithSwitch}>
          <Text style={styles.label}>Show padding details:</Text>
          <Switch onValueChange={() => setShowPaddingDetails(toggle)} value={showPaddingDetails} />
        </View>
        <View style={styles.labelWithSwitch}>
          <Text style={styles.label}>Padding:</Text>
        </View>
        <TextInput
          style={styles.input}
          onChangeText={(t) => onChangeNumeric(t, setPaddingSingle)}
          keyboardType="number-pad"
          placeholder="Single padding (applies to all)"
          value={paddingSingle}
        />
        {showPaddingDetails && (
          <View style={styles.paddingGrid}>
            <View style={styles.paddingRow}>
              <View style={styles.paddingCell}>
                <Text style={styles.smallLabel}>Top</Text>
                <TextInput
                  style={styles.input}
                  onChangeText={(t) => onChangeNumeric(t, setPaddingTop)}
                  keyboardType="number-pad"
                  placeholder="Top"
                  value={paddingTop}
                />
              </View>
              <View style={styles.paddingCell}>
                <Text style={styles.smallLabel}>Bottom</Text>
                <TextInput
                  style={styles.input}
                  onChangeText={(t) => onChangeNumeric(t, setPaddingBottom)}
                  keyboardType="number-pad"
                  placeholder="Bottom"
                  value={paddingBottom}
                />
              </View>
            </View>
            <View style={styles.paddingRow}>
              <View style={styles.paddingCell}>
                <Text style={styles.smallLabel}>Left</Text>
                <TextInput
                  style={styles.input}
                  onChangeText={(t) => onChangeNumeric(t, setPaddingLeft)}
                  keyboardType="number-pad"
                  placeholder="Left"
                  value={paddingLeft}
                />
              </View>
              <View style={styles.paddingCell}>
                <Text style={styles.smallLabel}>Right</Text>
                <TextInput
                  style={styles.input}
                  onChangeText={(t) => onChangeNumeric(t, setPaddingRight)}
                  keyboardType="number-pad"
                  placeholder="Right"
                  value={paddingRight}
                />
              </View>
            </View>
            <View style={styles.paddingRow}>
              <View style={styles.paddingCell}>
                <Text style={styles.smallLabel}>Vertical</Text>
                <TextInput
                  style={styles.input}
                  onChangeText={(t) => onChangeNumeric(t, setPaddingVertical)}
                  keyboardType="number-pad"
                  placeholder="Vertical"
                  value={paddingVertical}
                />
              </View>
              <View style={styles.paddingCell}>
                <Text style={styles.smallLabel}>Horizontal</Text>
                <TextInput
                  style={styles.input}
                  onChangeText={(t) => onChangeNumeric(t, setPaddingHorizontal)}
                  keyboardType="number-pad"
                  placeholder="Horizontal"
                  value={paddingHorizontal}
                />
              </View>
            </View>
          </View>
        )}
        {Platform.OS === 'ios' && (
          <>
            <View style={styles.labelWithSwitch}>
              <Text style={styles.label}>Countdown timer:</Text>
              <Switch
                onValueChange={() => {
                  setPassDate(toggle)
                  setPassProgress(false)
                  setPassElapsedTimer(false)
                  setPassStepProgress(false)
                }}
                value={passDate}
              />
            </View>
            <View style={styles.timerControlsContainer}>
              {passDate && (
                <RNDateTimePicker
                  value={date}
                  mode="time"
                  onChange={(event, date) => {
                    date && setDate(date)
                  }}
                  minimumDate={new Date(Date.now() + 60 * 1000)}
                />
              )}
            </View>
            <View style={styles.labelWithSwitch}>
              <Text style={styles.label}>Timer shown as text:</Text>
              <Switch
                onValueChange={() => {
                  setTimerTypeDigital(toggle)
                  setPassProgress(false)
                  setPassElapsedTimer(false)
                  setPassStepProgress(false)
                }}
                value={isTimerTypeDigital}
              />
            </View>
            <View style={styles.spacer} />
            <View style={styles.labelWithSwitch}>
              <Text style={styles.label}>Show progress:</Text>
              <Switch
                onValueChange={() => {
                  setPassProgress(toggle)
                  setPassDate(false)
                  setTimerTypeDigital(false)
                  setPassElapsedTimer(false)
                  setPassStepProgress(false)
                }}
                value={passProgress}
              />
            </View>
            <TextInput
              style={passProgress ? styles.input : styles.disabledInput}
              onChangeText={onChangeProgress}
              keyboardType="numeric"
              placeholder="Progress (0-1)"
              value={progress.toString()}
              editable={passProgress}
            />
            <View style={styles.spacer} />
            <View style={styles.labelWithSwitch}>
              <Text style={styles.label}>Elapsed timer:</Text>
              <Switch
                onValueChange={() => {
                  setPassElapsedTimer(toggle)
                  setPassDate(false)
                  setPassProgress(false)
                  setTimerTypeDigital(false)
                  setPassStepProgress(false)
                }}
                value={passElapsedTimer}
              />
            </View>
            {passElapsedTimer && (
              <>
                <View style={styles.labelWithSwitch}>
                  <Text style={styles.label}>Minutes ago started:</Text>
                </View>
                <TextInput
                  style={styles.input}
                  onChangeText={setElapsedTimerMinutesAgo}
                  keyboardType="number-pad"
                  placeholder="Minutes ago (e.g. 5)"
                  value={elapsedTimerMinutesAgo}
                />
              </>
            )}
            <View style={styles.spacer} />
            <View style={styles.labelWithSwitch}>
              <Text style={styles.label}>Show step progress:</Text>
              <Switch
                onValueChange={() => {
                  setPassStepProgress((prev) => {
                    const next = !prev
                    if (next) {
                      setPassDate(false)
                      setPassProgress(false)
                      setPassElapsedTimer(false)
                      setTimerTypeDigital(false)
                    }
                    return next
                  })
                }}
                value={passStepProgress}
              />
            </View>
            <View style={styles.labelWithSwitch}>
              <Text style={styles.label}>Current Step:</Text>
            </View>
            <TextInput
              style={passStepProgress ? styles.input : styles.disabledInput}
              onChangeText={(t) => onChangeNumeric(t, setCurrentStep)}
              keyboardType="number-pad"
              placeholder="Current step (e.g., 2)"
              value={currentStep}
              editable={passStepProgress}
              testID="input-current-step"
            />
            <View style={styles.labelWithSwitch}>
              <Text style={styles.label}>Total Steps:</Text>
            </View>
            <TextInput
              style={passStepProgress ? styles.input : styles.disabledInput}
              onChangeText={(t) => onChangeNumeric(t, setTotalSteps)}
              keyboardType="number-pad"
              placeholder="Total steps (e.g., 4)"
              value={totalSteps}
              editable={passStepProgress}
              testID="input-total-steps"
            />
            <View style={styles.labelWithSwitch}>
              <Text style={styles.label}>Active segment color:</Text>
            </View>
            <TextInput
              style={passStepProgress ? styles.input : styles.disabledInput}
              onChangeText={setSegmentActiveColor}
              placeholder="e.g., #22C55E"
              value={segmentActiveColor}
              editable={passStepProgress}
              autoCapitalize="none"
              testID="input-segment-active-color"
            />
            <View style={styles.labelWithSwitch}>
              <Text style={styles.label}>Inactive segment color:</Text>
            </View>
            <TextInput
              style={passStepProgress ? styles.input : styles.disabledInput}
              onChangeText={setSegmentInactiveColor}
              placeholder="e.g., #E5E7EB"
              value={segmentInactiveColor}
              editable={passStepProgress}
              autoCapitalize="none"
              testID="input-segment-inactive-color"
            />
          </>
        )}
        <View style={styles.buttonsContainer}>
          <Button
            title="Start Activity"
            onPress={startActivity}
            disabled={title === '' || !!activityId}
            testID="btn-start-activity"
          />
          <Button title="Stop Activity" onPress={stopActivity} disabled={!activityId} />
          <Button title="Update Activity" onPress={updateActivity} disabled={!activityId} />
        </View>
      </View>
    </ScrollView>
  )
}

const baseActivityConfig: LiveActivityConfig = {
  backgroundColor: '001A72',
  titleColor: 'EBEBF0',
  subtitleColor: '#FFFFFF75',
  progressViewTint: '38ACDD',
  progressViewLabelColor: '#FFFFFF',
  deepLinkUrl: '/dashboard',
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  scroll: {
    flex: 1,
  },
  timerControlsContainer: {
    flexDirection: 'row',
    marginTop: 15,
    marginBottom: 15,
    width: '90%',
    alignItems: 'center',
    justifyContent: 'center',
  },
  buttonsContainer: {
    padding: 30,
  },
  label: {
    width: '90%',
    fontSize: 17,
  },
  labelWithSwitch: {
    flexDirection: 'row',
    width: '90%',
    paddingEnd: 15,
  },
  smallLabel: {
    fontSize: 14,
    width: '90%',
  },
  input: {
    height: 45,
    width: '90%',
    marginVertical: 12,
    borderWidth: 1,
    borderColor: 'gray',
    borderRadius: 10,
    padding: 10,
  },
  disabledInput: {
    height: 45,
    width: '90%',
    margin: 12,
    borderWidth: 1,
    borderColor: '#DEDEDE',
    backgroundColor: '#ECECEC',
    color: 'gray',
    borderRadius: 10,
    padding: 10,
  },
  timerCheckboxContainer: {
    alignItems: 'flex-start',
    width: '90%',
    justifyContent: 'center',
  },
  spacer: {
    height: 16,
  },
  dropdown: {
    width: '90%',
    marginVertical: 8,
  },
  dropdownHeader: {
    height: 45,
    borderWidth: 1,
    borderColor: 'gray',
    borderRadius: 10,
    paddingHorizontal: 12,
    alignItems: 'center',
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  dropdownHeaderDisabled: {
    height: 45,
    borderWidth: 1,
    borderColor: '#DEDEDE',
    backgroundColor: '#ECECEC',
    borderRadius: 10,
    paddingHorizontal: 12,
    alignItems: 'center',
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  dropdownTextDisabled: {
    color: 'gray',
  },
  dropdownList: {
    borderWidth: 1,
    borderColor: 'gray',
    borderRadius: 10,
    marginTop: 4,
  },
  dropdownItem: {
    paddingVertical: 10,
    paddingHorizontal: 12,
  },
  paddingGrid: {
    width: '90%',
  },
  paddingRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  paddingCell: {
    width: '48%',
  },
})

type DropdownOption = { label: string; value: string }

function Dropdown({
  value,
  onChange,
  options,
  testID,
  disabled,
}: {
  value: string
  onChange: (val: string) => void
  options: DropdownOption[]
  testID?: string
  disabled?: boolean
}) {
  const [open, setOpen] = useState(false)
  const selected = options.find((o) => o.value === value) ?? options[0]

  return (
    <View style={styles.dropdown} testID={testID}>
      <Pressable
        style={disabled ? styles.dropdownHeaderDisabled : styles.dropdownHeader}
        disabled={disabled}
        onPress={() => {
          if (Platform.OS === 'ios') {
            const labels = options.map((o) => o.label)
            ActionSheetIOS.showActionSheetWithOptions(
              {
                options: [...labels, 'Cancel'],
                cancelButtonIndex: labels.length,
              },
              (buttonIndex) => {
                if (buttonIndex !== undefined && buttonIndex < labels.length) {
                  onChange(options[buttonIndex].value)
                }
              }
            )
          } else {
            setOpen((o) => !o)
          }
        }}
      >
        <Text style={disabled ? styles.dropdownTextDisabled : undefined}>{selected.label}</Text>
        <Text style={disabled ? styles.dropdownTextDisabled : undefined}>{open ? '▲' : '▼'}</Text>
      </Pressable>
      {Platform.OS !== 'ios' && open && !disabled && (
        <View style={styles.dropdownList}>
          {options.map((opt) => (
            <Pressable
              key={opt.value}
              style={styles.dropdownItem}
              onPress={() => {
                onChange(opt.value)
                setOpen(false)
              }}
            >
              <Text>{opt.label}</Text>
            </Pressable>
          ))}
        </View>
      )}
    </View>
  )
}
