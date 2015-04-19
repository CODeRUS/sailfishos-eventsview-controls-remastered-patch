import QtQuick 2.1
import Sailfish.Silica 1.0
import com.jolla.settings 1.0
import org.nemomobile.configuration 1.0

Column {
    id: root
    width: Screen.width
    spacing: Theme.paddingLarge

    ConfigurationGroup {
        id: eventsviewSettings
        path: "/desktop/lipstick-jolla-home/eventsviewControls"
        property int maximumGridRows: 2
        property int maximumListRows: 2
        property bool showOnlySwitches: true
        property int gridColumns: 4
        property bool alignGridToBottom: false
    }

    Grid {
        id: gridFavorites
        columns: eventsviewSettings.gridColumns
        rows: Math.min(Math.ceil(eventsviewSettings.showOnlySwitches ? switchesCount : gridRepeater.count / eventsviewSettings.gridColumns), eventsviewSettings.maximumGridRows)
        width: root.width
        verticalItemAlignment: eventsviewSettings.alignGridToBottom ? Grid.AlignBottom : Grid.AlignVCenter
        clip: true
        property int switchesCount: 0
        signal postRefresh

        Repeater {
            id: gridRepeater
            model: FavoritesModel { filter: "grid_favorites" }
            onCountChanged: {
                gridFavorites.switchesCount = 0
                gridFavorites.postRefresh()
            }

            delegate: Item {
                id: gridWrapper
                height: gridLoader.height
                width:  gridLoader.width
                visible: (customType  || !eventsviewSettings.showOnlySwitches) && index < (eventsviewSettings.gridColumns * gridFavorites.rows)
                property bool customType: model.object.type === "custom" && model.object.data()["params"]
                property int originalHeight
                Connections {
                    target: gridFavorites
                    onPostRefresh: {
                        if (customType) {
                            gridFavorites.switchesCount += 1
                        }
                    }
                }
                Binding {
                    target: gridLoader
                    property: "height"
                    value: gridWrapper.originalHeight
                    when: gridLoader.status == Loader.Ready && eventsviewSettings.alignGridToBottom
                }
                Binding {
                    target: gridLoader
                    property: "height"
                    value: gridLoader.width
                    when: gridLoader.status == Loader.Ready && !eventsviewSettings.alignGridToBottom
                }
                Component.onCompleted: {
                    if (customType) {
                        gridFavorites.switchesCount += 1
                    }
                }
                Component.onDestruction: {
                    if (customType) {
                        gridFavorites.switchesCount -= 1
                    }
                }
                SettingComponentLoader {
                    id: gridLoader
                    width: root.width / eventsviewSettings.gridColumns
                    settingsObject: model.object
                    gridMode: true
                    onLoaded: gridWrapper.originalHeight = item.height
                }
                Binding {
                    target: gridLoader.item
                    property: "highlighted"
                    value: gridLoader.item && gridLoader.item.down
                }
                Binding {
                    target: gridLoader.item
                    property: "_backgroundColor"
                    value: Theme.rgba(Theme.highlightBackgroundColor, gridLoader.item && gridLoader.item.down ?
                                          Theme.highlightBackgroundOpacity : 0)
                }
            }
        }
    }

    Grid {
        id: listFavorites
        width: root.width
        columns: 1
        rows: Math.min(listRepeater.count, eventsviewSettings.maximumListRows)
        visible: rows > 0
        clip: true
        Repeater {
            id: listRepeater
            model: FavoritesModel { filter: "list_favorites" }
            delegate: Item {
                id: listWrapper
                height: listLoader.height
                width: root.width
                visible: index < listFavorites.rows
                SettingComponentLoader {
                    id: listLoader
                    width: root.width
                    settingsObject: model.object
                }
                Binding {
                    target: listLoader.item
                    property: "highlighted"
                    value: listLoader.item && listLoader.item.down
                }
                Binding {
                    target: listLoader.item
                    property: "_backgroundColor"
                    value: Theme.rgba(Theme.highlightBackgroundColor, listLoader.item && listLoader.item.down ?
                                          Theme.highlightBackgroundOpacity : 0)
                }
            }
        }
    }
}
