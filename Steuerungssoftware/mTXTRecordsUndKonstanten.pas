{
Dieses Modul enthält verschiedene Records und Konstanten, die für das TXT-
Protokoll benutzt werden.

@author Michael Gebing, Sven Stegemann
@date 21.12.2015

Copyright © 2015 FH Münster

Diese Datei ist Teil von libTXT.

libTXT ist Freie Software: Sie können es unter den Bedingungen
der GNU General Public License, wie von der Free Software Foundation,
Version 3 der Lizenz oder (nach Ihrer Wahl) jeder späteren
veröffentlichten Version, weiterverbreiten und/oder modifizieren.

libTXT wird in der Hoffnung, dass es nützlich sein wird, aber
OHNE JEDE GEWÄHRLEISTUNG, bereitgestellt; sogar ohne die implizite
Gewährleistung der MARKTFÄHIGKEIT oder EIGNUNG FÜR EINEN BESTIMMTEN ZWECK.
Siehe die GNU General Public License für weitere Details.

Sie sollten eine Kopie der GNU General Public License zusammen mit diesem
Programm erhalten haben. Wenn nicht, siehe http://www.gnu.org/licenses/.
}

unit mTXTRecordsUndKonstanten;

interface

  const
  ftIF2013CommandId_QueryStatus = $DC21219A;

  ftIF2013CommandId_StartOnline = $163FF61D;
  ftIF2013CommandId_UpdateConfig = $060EF27E;
  ftIF2013CommandId_ExchangeData = $CC3597BA;
  ftIF2013CommandId_ExchangeDataCmpr = $FBC56F98;
  ftIF2013CommandId_StopOnline = $9BE5082C;

  ftIF2013CommandId_StartCameraOnline = $882A40A6;
  ftIF2013CommandId_StopCameraOnline = $17C31F2F;

  // Used in camera channel
  ftIF2013AcknowledgeId_CameraOnlineFrame = $ADA09FBA;

  type
    ftIF2013Command_ExchangeData = packed record
      // Motor / Output PWM data
      // Also for bipolar motor outputs both values are used
      m_id: UINT32;
      m_pwmOutputValues : array [0 .. 7] of INT16;
      m_motor_master: array [0 .. 3] of INT16;

      m_motor_distance : array [0 .. 3] of INT16;
      m_motor_command_id : array [0 .. 3] of INT16;
      m_counter_reset_command_id : array [0 .. 3] of INT16;
      m_sound_command_id : UINT16;
      m_sound_index : UINT16;
      m_sound_repeat : UINT16;
      dummy:int16;
    end;

    CNT_CONFIG = packed record
      mode: UINT8; // 1=normal, 0=inverted;
      dummy: array[0..2] of AnsiChar;
    end;

    UNI_CONFIG= packed record
      mode : UINT8;      // enum InputMode  mode
      digital : BOOLEAN;
      dummy : array [0..1] of AnsiChar;
    end;

    TFTX1_CONFIG = packed record
      // TX-only: Program run state
      pgm_state_req: UINT8; // enum PgmState    pgm_state_req;
      old_FtTransfer: Uint8;
      dummy: array[0..1] of AnsiChar;

      // Configuration of motrs
      // 0=single output O1/O2, 1=motor output M1
      motor: array [0 .. 3] of UINT8;
      // Universal input mode, see enum InputMode
      uni: array [0 .. 7] of UNI_CONFIG;
      // 0=normal, 1=inverted (not really used)
      cnt: array [0 .. 3] of CNT_CONFIG;
      // additional motor configuration data (currently not used)
      motor_config: array [0..3] of array [0..3] of INT16;
    end;

  ftIF2013Command_UpdateConfig = packed record
     m_id: INT32;
     m_config_id: INT16;
     m_extension_id: INT16;
     m_config: TFTX1_CONFIG;
  end;

  ftIF2013ResponseId = (ftIF2013ResponseId_QueryStatus = $BAC9723E,
    ftIF2013ResponseId_StartOnline = $CA689F75,
    ftIF2013ResponseId_UpdateConfig = $9689A68C,
    ftIF2013ResponseId_ExchangeData = $4EEFAC41,
    ftIF2013ResponseId_ExchangeDataCmpr = $6F3B54E6,
    ftIF2013ResponseId_StopOnline = $FBF600D2,

    ftIF2013ResponseId_StartCameraOnline = $CF41B24E,
    ftIF2013ResponseId_StopCameraOnline = $4B3C1EB6,

    // Used in camera channel
    ftIF2013DataId_CameraOnlineFrame = $BDC2D7A1);

    IR = packed record
      m_ir_leftX: byte; // INT8; // left  handle, horizontal, -15..15
      m_ir_leftY: byte; // INT8; // left  handle, vertical,   -15..15
      m_ir_rightX: byte; // INT8; // right handle, horizontal, -15..15
      m_ir_rightY: byte; // INT8; // right handle, vertical,   -15..15
      m_ir_bits: byte; // UINT8; // 2^0=on, 2^1=off, 2^2=switch1, 2^3=switch2
    end;
                                                                      ///////////////////////
    ftIF2013Response_ExchangeData = packed record
      // Universal input values
      m_id: UINT32;
      m_universalInputs: array [0 .. 7] of INT16;
      m_counter_input: array [0 .. 3] of INT16;
      m_counter_value: array [0 .. 3] of INT16;
      m_counter_command_id: array [0 .. 3] of INT16;
      m_motor_command_id: array [0 .. 3] of INT16;
      m_sound_command_id: INT16;
      m_ir: array[0..4] of IR;
    end;

    ftIF2013Response_QueryStatus = packed record
      m_id: UINT32;
      m_devicename: array [0..15] of AnsiChar;
      m_version: UINT32;
    end;

    InputMode = (
    MODE_U = 0,
    MODE_R,
    MODE_R2,
    MODE_ULTRASONIC,
    MODE_INVALID);

    // Senden über Port 65000 zum Starten der Kamera.
    FTXStartCam = packed record
      m_id: int32; // $CF41B24E;
      m_width: int32;
      m_height: int32;
      m_framerate: int32;
      m_powerlinefreq: int32; // 0=auto, 1=50Hz, 2=60Hz
    end;

    KameraData = packed record
    m_id: Integer;

    m_numframerady: int32;
    m_framewidth: INT16;
    m_frameheight: INT16;
    m_framesizeraw: int32;
    m_framesizecompressed: int32;
    // m_framedata : array of UINT8;
  end;


implementation

end.
