/*
 * Copyright (c) 2011-2012 Research In Motion Limited.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import bb.cascades 1.0

NavigationPane {
    id: navigationPane

    onPopTransitionEnded: page.destroy()

    Page {
        //! [0]
        function pushPane()
        {
            navigationPane.push(viewTypes.selectedValue.createObject())
        }

        onCreationCompleted: _timeline.tweetsLoaded.connect(pushPane)
        //! [0]

        Container {
            layout: DockLayout {}

            Container {
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill

                topPadding: 20
                leftPadding: 20
                rightPadding: 20
                bottomPadding: 20

                layout: DockLayout {}

                Container {
                    id: screenInfo
                    verticalAlignment: VerticalAlignment.Top

                    Label {
                        text: qsTr("Let's Search For Some Tools Shall we? ")
                        textStyle {
                            color: Color.Gray
                        }
                    }

                    TextField {
                        id: txtUrl
                        hintText: "Enter the URL of tools database upto  searchTools.xsp"
                        textFormat: TextFormat.Plain
                        text: "http://192.168.204.1:9090/keystone/build8/tools.nsf/searchTools.xsp"

                    }
                    TextField {
                        id: txtUname
                        hintText: "Enter Domino Login "
                        textFormat: TextFormat.Plain

                    }
                    TextField {
                        id: txtPwd
                        
                        textFormat: TextFormat.Plain
                        inputMode: TextFieldInputMode.Password
                        hintText: "Enter password"

                    }
                    Divider {

                    }
                    DateTimePicker {
                        id: startDatePicker

                        title: "Select a start date"
                        expanded: false

                    }

                    DateTimePicker {
                        id: endDatePicker

                        title: "Select an end date"

                    }

                    Button {
                        horizontalAlignment: HorizontalAlignment.Center

                        enabled: !_timeline.active

                        text: qsTr("Search")
                        onClicked: {
                            _timeline.requestTweets(startDatePicker.value,endDatePicker.value,txtUrl.text,txtUname.text,txtPwd.text);
                        }
                    }
                    //! [1]
                }

                //! [2]
                Label {
                    verticalAlignment: VerticalAlignment.Center

                    visible: _timeline.error

                    multiline: true

                    text: _timeline.errorMessage
                    textStyle {
                        base: SystemDefaults.TextStyles.BigText;
                        color: Color.Gray
                    }
                }
                //! [2]

                Container {
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Bottom

                    Label {
                        horizontalAlignment: HorizontalAlignment.Center

                        text: qsTr("Select a ListView type for\ndisplaying the Tools")
                        textStyle {
                            color: Color.Gray
                            textAlign: TextAlign.Center
                        }
                        multiline: true
                    }

                    //! [3]
                    SegmentedControl {
                        id: viewTypes

                        Option {
                            id: basicView
                            text: qsTr("Standard")
                            value: standardViewPage
                            selected: true
                        }

                        Option {
                            id: richView
                            text: qsTr("Custom")
                            value: customViewPage
                        }
                    }
                    //! [3]
                }
            }
        }

        //! [4]
        attachedObjects: [
            ComponentDefinition {
                id: standardViewPage
                source: "StandardTimelineView.qml"
            },
            ComponentDefinition {
                id: customViewPage
                source: "CustomTimelineView.qml"
            }
        ]
        //! [4]
    }
}
