import QtQuick 2.0
import Sailfish.Silica 1.0
import org.nemomobile.configuration 1.0

Page {
	id: page

    ConfigurationGroup {
        id: eventsviewSettings
        path: "/desktop/lipstick-jolla-home/eventsviewControls"
        property int maximumGridRows: 2
        property int maximumListRows: 2
        property bool showOnlySwitches: true
    }

	SilicaFlickable {
		anchors.fill: parent
		contentHeight: content.height
		interactive: contentHeight > height

		Column {
			width: parent.width
			spacing: Theme.paddingLarge

			PageHeader {
				title: "Eventsview controls settings"
			}

			Slider {
				width: parent.width
			    label: "Maximum grid rows"
			    maximumValue: 5
			    minimumValue: 1
			    stepSize: 1
			    value: eventsviewSettings.maximumGridRows
			    valueText: value

			    onValueChanged: eventsviewSettings.maximumGridRows = Math.round(value)
			    onPressAndHold: cancel()
			}

			Slider {
				width: parent.width
			    label: "Maximum list rows"
			    maximumValue: 5
			    minimumValue: 0
			    stepSize: 1
			    value: eventsviewSettings.maximumListRows
			    valueText: value

			    onValueChanged: eventsviewSettings.maximumListRows = Math.round(value)
			    onPressAndHold: cancel()
			}

			TextSwitch {
				width: parent.width
				text: "Show only switch controls in grid"
				checked: eventsviewSettings.showOnlySwitches
				onClicked: eventsviewSettings.showOnlySwitches = checked
			}
		}
	}
}
