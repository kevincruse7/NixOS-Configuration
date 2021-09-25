{writeText, ...}:

writeText "monitors.xml" ''
    <monitors version="2">
        <configuration>
            <logicalmonitor>
                <x>1920</x>
                <y>0</y>
                <scale>1</scale>
                <monitor>
                    <monitorspec>
                        <connector>eDP-1</connector>
                        <vendor>SHP</vendor>
                        <product>0x14ba</product>
                        <serial>0x00000000</serial>
                    </monitorspec>
                    <mode>
                        <width>1920</width>
                        <height>1080</height>
                        <rate>60</rate>
                    </mode>
                </monitor>
            </logicalmonitor>
            <logicalmonitor>
                <x>0</x>
                <y>0</y>
                <scale>1</scale>
                <primary>yes</primary>
                <monitor>
                    <monitorspec>
                        <connector>DP-1</connector>
                        <vendor>ACR</vendor>
                        <product>SB220Q</product>
                        <serial>0x11102137</serial>
                    </monitorspec>
                    <mode>
                        <width>1920</width>
                        <height>1080</height>
                        <rate>60</rate>
                    </mode>
                </monitor>
            </logicalmonitor>
        </configuration>
        <configuration>
            <logicalmonitor>
                <x>0</x>
                <y>0</y>
                <scale>1</scale>
                <primary>yes</primary>
                <monitor>
                    <monitorspec>
                        <connector>eDP-1</connector>
                        <vendor>SHP</vendor>
                        <product>0x14ba</product>
                        <serial>0x00000000</serial>
                    </monitorspec>
                    <mode>
                        <width>1920</width>
                        <height>1080</height>
                        <rate>60</rate>
                    </mode>
                </monitor>
            </logicalmonitor>
        </configuration>
        <configuration>
            <logicalmonitor>
                <x>0</x>
                <y>0</y>
                <scale>1</scale>
                <primary>yes</primary>
                <monitor>
                    <monitorspec>
                        <connector>DP-1</connector>
                        <vendor>ACR</vendor>
                        <product>SB220Q</product>
                        <serial>0x11102137</serial>
                    </monitorspec>
                    <mode>
                        <width>1920</width>
                        <height>1080</height>
                        <rate>60</rate>
                    </mode>
                </monitor>
            </logicalmonitor>
        </configuration>
    </monitors>
''
