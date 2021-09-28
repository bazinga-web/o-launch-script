#!/usr/bin/env ruby

# You can generate json by executing the following command on Terminal.
#
# $ ruby ./CreateLauncherModeTemplate.json.rb
#

# Parameters

def parameters
  {
    :simultaneous_threshold_milliseconds => 500,
    :trigger_key => 'o',
  }
end

############################################################

require 'json'

def main
  data = {
    'description' => 'O-Launcher By tsq',
    'manipulators' => [
      generate_launcher_mode('n', [], [{ 'shell_command' => "open -a 'notion.app'" }]),
      generate_launcher_mode('c', [], [{ 'shell_command' => "open -a 'Visual Studio Code.app'" }]),
      generate_launcher_mode('i', [], [{ 'shell_command' => "open -a 'iTerm.app'" }]),
      generate_launcher_mode('w', [], [{ 'shell_command' => "open -a 'WeChat.app'" }]),
      generate_launcher_mode('g', [], [{ 'shell_command' => "open -a 'Google Chrome.app'" }]),
      generate_launcher_mode('d', [], [{ 'shell_command' => "open -a 'DingTalk.app'" }]),
      generate_launcher_mode('e', [], [{ 'shell_command' => "open -a 'Microsoft Edge.app'" }]),
      generate_launcher_mode('t', [], [{ 'shell_command' => "open -a 'Typora.app'" }]),
      generate_launcher_mode('v', [], [{ 'shell_command' => "open -a 'IINA.app'" }]),
    ].flatten,
  }

  puts JSON.pretty_generate(data)
end

def generate_launcher_mode(from_key_code, mandatory_modifiers, to)
  data = []

  ############################################################

  h = {
    'type' => 'basic',
    'from' => {
      'key_code' => from_key_code,
      'modifiers' => {
        'mandatory' => mandatory_modifiers,
        'optional' => [
          'any',
        ],
      },
    },
    'to' => to,
    'conditions' => [
      {
        'type' => 'variable_if',
        'name' => 'launcher_mode',
        'value' => 1,
      },
    ],
  }

  data << h

  ############################################################

  h = {
    'type' => 'basic',
    'from' => {
      'simultaneous' => [
        {
          'key_code' => parameters[:trigger_key],
        },
        {
          'key_code' => from_key_code,
        },
      ],
      'simultaneous_options' => {
        'key_down_order' => 'strict',
        'key_up_order' => 'strict_inverse',
        'to_after_key_up' => [
          {
            'set_variable' => {
              'name' => 'launcher_mode',
              'value' => 0,
            },
          },
        ],
      },
      'modifiers' => {
        'mandatory' => mandatory_modifiers,
        'optional' => [
          'any',
        ],
      },
    },
    'to' => [
      {
        'set_variable' => {
          'name' => 'launcher_mode',
          'value' => 1,
        },
      },
    ].concat(to),
    'parameters' => {
      'basic.simultaneous_threshold_milliseconds' => parameters[:simultaneous_threshold_milliseconds],
    },
  }

  data << h

  ############################################################

  data
end

main