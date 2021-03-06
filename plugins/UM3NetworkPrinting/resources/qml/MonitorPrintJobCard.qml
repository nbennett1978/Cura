// Copyright (c) 2018 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.2
import QtQuick.Controls 2.0
import UM 1.3 as UM

/**
 * A Print Job Card is essentially just a filled-in Expandable Card item. All
 * data within it is derived from being passed a printJob property.
 *
 * NOTE: For most labels, a fixed height with vertical alignment is used to make
 * layouts more deterministic (like the fixed-size textboxes used in original
 * mock-ups). This is also a stand-in for CSS's 'line-height' property. Denoted
 * with '// FIXED-LINE-HEIGHT:'.
 */
Item
{
    id: base

    // The print job which all other data is derived from
    property var printJob: null

    width: parent.width
    height: childrenRect.height

    ExpandableCard
    {
        enabled: printJob != null
        borderColor: printJob.configurationChanges.length !== 0 ? "#f5a623" : "#CCCCCC" // TODO: Theme!
        headerItem: Row
        {
            height: 48 * screenScaleFactor // TODO: Theme!
            anchors.left: parent.left
            anchors.leftMargin: 24 * screenScaleFactor // TODO: Theme!
            spacing: 18 * screenScaleFactor // TODO: Theme!

            MonitorPrintJobPreview
            {
                printJob: base.printJob
                size: 32 * screenScaleFactor // TODO: Theme!
                anchors.verticalCenter: parent.verticalCenter
            }

            Item
            {
                anchors.verticalCenter: parent.verticalCenter
                height: 18 * screenScaleFactor // TODO: Theme!
                width: 216 * screenScaleFactor // TODO: Theme! (Should match column size)
                Rectangle
                {
                    color: "#eeeeee"
                    width: Math.round(parent.width / 2)
                    height: parent.height
                    visible: !printJob
                }
                Label
                {
                    text: printJob && printJob.name ? printJob.name : ""
                    color: "#374355"
                    elide: Text.ElideRight
                    font: UM.Theme.getFont("medium") // 14pt, regular
                    visible: printJob

                    // FIXED-LINE-HEIGHT:
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Item
            {
                anchors.verticalCenter: parent.verticalCenter
                height: 18 * screenScaleFactor // TODO: Theme!
                width: 216 * screenScaleFactor // TODO: Theme! (Should match column size)
                Rectangle
                {
                    color: "#eeeeee"
                    width: Math.round(parent.width / 3)
                    height: parent.height
                    visible: !printJob
                }
                Label
                {
                    text: printJob ? OutputDevice.formatDuration(printJob.timeTotal) : ""
                    color: "#374355"
                    elide: Text.ElideRight
                    font: UM.Theme.getFont("medium") // 14pt, regular
                    visible: printJob

                    // FIXED-LINE-HEIGHT:
                    height: 18 * screenScaleFactor // TODO: Theme!
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Item
            {
                anchors.verticalCenter: parent.verticalCenter
                height: 18 * screenScaleFactor // TODO: This should be childrenRect.height but QML throws warnings
                width: childrenRect.width

                Rectangle
                {
                    color: "#eeeeee"
                    width: 72 * screenScaleFactor // TODO: Theme!
                    height: parent.height
                    visible: !printJob
                }

                Label
                {
                    id: printerAssignmentLabel
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#374355"
                    elide: Text.ElideRight
                    font: UM.Theme.getFont("medium") // 14pt, regular
                    text: {
                        if (printJob !== null) {
                            if (printJob.assignedPrinter == null)
                            {
                                if (printJob.state == "error")
                                {
                                    return catalog.i18nc("@label", "Unavailable printer")
                                }
                                return catalog.i18nc("@label", "First available")
                            }
                            return printJob.assignedPrinter.name
                        }
                        return ""
                    }
                    visible: printJob
                    width: 120 * screenScaleFactor // TODO: Theme!

                    // FIXED-LINE-HEIGHT:
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                }

                Row
                {
                    id: printerFamilyPills
                    anchors
                    {
                        left: printerAssignmentLabel.right;
                        leftMargin: 12 // TODO: Theme!
                        verticalCenter: parent.verticalCenter
                    }
                    height: childrenRect.height
                    spacing: 6 // TODO: Theme!
                    visible: printJob

                    Repeater
                    {
                        id: compatiblePills
                        delegate: MonitorPrinterPill
                        {
                            text: modelData
                        }
                        model: printJob ? printJob.compatibleMachineFamilies : []
                    }
                }
            }
        }
        drawerItem: Row
        {
            anchors
            {
                left: parent.left
                leftMargin: 74 * screenScaleFactor // TODO: Theme!
            }
            height: 108 * screenScaleFactor // TODO: Theme!
            spacing: 18 * screenScaleFactor // TODO: Theme!

            MonitorPrinterConfiguration
            {
                id: printerConfiguration
                anchors.verticalCenter: parent.verticalCenter
                buildplate: "Glass"
                configurations:
                [
                    base.printJob.configuration.extruderConfigurations[0],
                    base.printJob.configuration.extruderConfigurations[1]
                ]
                height: 72 * screenScaleFactor // TODO: Theme!
            }
            Label {
                text: printJob && printJob.owner ? printJob.owner : ""
                color: "#374355" // TODO: Theme!
                elide: Text.ElideRight
                font: UM.Theme.getFont("medium") // 14pt, regular
                anchors.top: printerConfiguration.top

                // FIXED-LINE-HEIGHT:
                height: 18 * screenScaleFactor // TODO: Theme!
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    PrintJobContextMenu
    {
        id: contextButton
        anchors
        {
            right: parent.right;
            rightMargin: 8 * screenScaleFactor // TODO: Theme!
            top: parent.top
            topMargin: 8 * screenScaleFactor // TODO: Theme!
        }
        printJob: base.printJob
        width: 32 * screenScaleFactor // TODO: Theme!
        height: 32 * screenScaleFactor // TODO: Theme!
    }
}