defmodule ExTwimlTest do
  use ExUnit.Case, async: false

  import ExTwiml

  alias ExTwiml.ReservedNameError

  doctest ExTwiml

  test "can render the <Gather> verb" do
    markup =
      twiml do
        gather digits: 3 do
          text("Phone Number")
        end
      end

    assert_twiml(markup, "<Gather digits=\"3\">Phone Number</Gather>")
  end

  test "can render the <Gather> verb without any options" do
    markup =
      twiml do
        gather do
          text("Phone Number")
        end
      end

    assert_twiml(markup, "<Gather>Phone Number</Gather>")
  end

  test "can render the <Say> verb" do
    markup =
      twiml do
        say("Hello there!", voice: "woman")
      end

    assert_twiml(markup, "<Say voice=\"woman\">Hello there!</Say>")
  end

  test "can render the <Record> verb" do
    markup =
      twiml do
        record(finish_on_key: "#", transcribe: true)
      end

    assert_twiml(markup, "<Record finishOnKey=\"#\" transcribe=\"true\" />")
  end

  test "can render the <Number> verb" do
    markup =
      twiml do
        number("1112223333")
      end

    assert_twiml(markup, "<Number>1112223333</Number>")
  end

  test "can render the <Play> verb" do
    markup =
      twiml do
        play("https://api.twilio.com/cowbell.mp3", loop: 10)
      end

    assert_twiml(markup, "<Play loop=\"10\">https://api.twilio.com/cowbell.mp3</Play>")
  end

  test "can render the <Sms> verb" do
    markup =
      twiml do
        sms("Hello world!", from: "1112223333", to: "2223334444")
      end

    assert_twiml(markup, "<Sms from=\"1112223333\" to=\"2223334444\">Hello world!</Sms>")
  end

  test "can render the <Dial> verb" do
    markup =
      twiml do
        dial action: "/calls/new" do
          number("1112223333")
        end
      end

    assert_twiml(markup, "<Dial action=\"/calls/new\"><Number>1112223333</Number></Dial>")
  end

  test "can render the <Sip> verb" do
    markup =
      twiml do
        sip("sip:test@example.com", username: "admin", password: "123")
      end

    assert_twiml(markup, "<Sip username=\"admin\" password=\"123\">sip:test@example.com</Sip>")
  end

  test "can render the <Client> verb" do
    markup =
      twiml do
        client("Daniel")
        client("Bob")
      end

    assert_twiml(markup, "<Client>Daniel</Client><Client>Bob</Client>")
  end

  test "can render the <Conference> verb" do
    markup =
      twiml do
        conference("Friendly Conference", end_conference_on_exit: true)
      end

    assert_twiml(
      markup,
      "<Conference endConferenceOnExit=\"true\">Friendly Conference</Conference>"
    )
  end

  test "can render the <Queue> verb" do
    markup =
      twiml do
        queue("support", url: "about_to_connect.xml")
      end

    assert_twiml(markup, "<Queue url=\"about_to_connect.xml\">support</Queue>")
  end

  test "can render the <Enqueue> verb" do
    markup =
      twiml do
        enqueue("support", wait_url: "wait-music.xml")
      end

    assert_twiml(markup, "<Enqueue waitUrl=\"wait-music.xml\">support</Enqueue>")
  end

  test "can render the <Task> verb" do
    markup =
      twiml do
        task(~s({"selected_language": "it"}))
      end

    assert_twiml(markup, ~s(<Task>{&quot;selected_language&quot;: &quot;it&quot;}</Task>))
  end

  test "can render the <Task> verb nested inside an <Enqueue> verb" do
    markup =
      twiml do
        enqueue do
          task(~s({"selected_language": "it"}))
        end
      end

    assert_twiml(
      markup,
      ~s(<Enqueue><Task>{&quot;selected_language&quot;: &quot;it&quot;}</Task></Enqueue>)
    )
  end

  test "can render the <Leave> verb" do
    markup =
      twiml do
        leave
      end

    assert_twiml(markup, "<Leave />")
  end

  test "can render the <Hangup> verb" do
    markup =
      twiml do
        hangup
      end

    assert_twiml(markup, "<Hangup />")
  end

  test "can render the <Redirect> verb" do
    markup =
      twiml do
        redirect("http://example.com", method: "POST")
      end

    assert_twiml(markup, "<Redirect method=\"POST\">http://example.com</Redirect>")
  end

  test "can render the <Reject> verb" do
    markup =
      twiml do
        reject(reason: "busy")
      end

    assert_twiml(markup, "<Reject reason=\"busy\" />")

    markup =
      twiml do
        reject
      end

    assert_twiml(markup, "<Reject />")
  end

  test "can render the <Pause> verb" do
    markup =
      twiml do
        pause(length: 5)
      end

    assert_twiml(markup, "<Pause length=\"5\" />")
  end

  test "can render the <Message> verb" do
    markup =
      twiml do
        message action: "/hello", method: "post" do
        end
      end

    assert_twiml(markup, "<Message action=\"/hello\" method=\"post\"></Message>")
  end

  test "can render the <Body> verb" do
    markup =
      twiml do
        body("Store location: 203")
      end

    assert_twiml(markup, "<Body>Store location: 203</Body>")
  end

  test "can render the <Media> verb" do
    markup =
      twiml do
        media("https://demo.twilio.com/owl.png")
      end

    assert_twiml(markup, "<Media>https://demo.twilio.com/owl.png</Media>")
  end

  test "can render the <Identity> verb" do
    markup =
      twiml do
        identity("emma_softphone_client")
      end

    assert_twiml(markup, "<Identity>emma_softphone_client</Identity>")
  end

  test "can render the <Parameter> verb" do
    markup =
      twiml do
        parameter(name: "neatNewParamKey", value: "neatNewParamValue")
      end

    assert_twiml(markup, "<Parameter name=\"neatNewParamKey\" value=\"neatNewParamValue\" />")
  end

  test "can render the <Client> verb with <Identity> and <Param>s" do
    markup =
      twiml do
        client do
          identity("emma_softphone_client")
          parameter(name: "neatNewParamKey", value: "neatNewParamValue")
          parameter(name: "neatNewParamKey2", value: "neatNewParamValue2")
        end
      end

    assert_twiml(
      markup,
      "<Client><Identity>emma_softphone_client</Identity><Parameter name=\"neatNewParamKey\" value=\"neatNewParamValue\" /><Parameter name=\"neatNewParamKey2\" value=\"neatNewParamValue2\" /></Client>"
    )
  end

  test ".twiml can include Enum loops" do
    markup =
      twiml do
        Enum.each(1..3, fn n ->
          say("Press #{n}")
        end)
      end

    assert_twiml(markup, "<Say>Press 1</Say><Say>Press 2</Say><Say>Press 3</Say>")
  end

  test ".twiml can loop through lists of maps" do
    people = [%{name: "Daniel"}, %{name: "Hunter"}]

    markup =
      twiml do
        Enum.each(people, fn person ->
          say("Hello, #{person.name}!")
        end)
      end

    assert_twiml(markup, "<Say>Hello, Daniel!</Say><Say>Hello, Hunter!</Say>")
  end

  test ".twiml can 'say' a variable that happens to be a string" do
    some_var = "hello world"

    markup =
      twiml do
        say(some_var)
      end

    assert_twiml(markup, "<Say>hello world</Say>")
  end

  test ".twiml can 'say' an integer variable" do
    integer = 123

    markup =
      twiml do
        say(integer)
      end

    assert_twiml(markup, "<Say>123</Say>")
  end

  test ".twiml simple verbs can take options as a variable" do
    options = [voice: "alice"]

    markup =
      twiml do
        say("I'm Alice", options)
      end

    assert_twiml(markup, "<Say voice=\"alice\">I&apos;m Alice</Say>")
  end

  test ".twiml self-closing verbs can take options as a variable" do
    options = [length: 31]

    markup =
      twiml do
        pause(options)
      end

    assert_twiml(markup, "<Pause length=\"31\" />")
  end

  test ".twiml nested verbs can take options as a variable" do
    options = [method: "GET"]

    markup =
      twiml do
        gather options do
          say("Hi")
        end
      end

    assert_twiml(markup, "<Gather method=\"GET\"><Say>Hi</Say></Gather>")
  end

  test ".twiml warns of reserved variable names" do
    ast =
      quote do
        twiml do
          Enum.each([1, 2], fn number, text ->
            say("#{number}")
          end)
        end
      end

    assert_raise ReservedNameError, fn ->
      # Simulate compiling the macro
      Macro.expand(ast, __ENV__)
    end
  end

  test "escape message body" do
    markup =
      twiml do
        message do
          body("hello :<")
        end
      end

    assert_twiml(markup, "<Message><Body>hello :&lt;</Body></Message>")
  end

  test "escape simple text" do
    markup =
      twiml do
        text("hello :<")
      end

    assert_twiml(markup, "hello :&lt;")
  end

  test "escape attribute" do
    markup =
      twiml do
        tag :mms, to: "112345'" do
          text("hello")
        end
      end

    assert_twiml(markup, "<Mms to=\"112345&apos;\">hello</Mms>")
  end

  test "can render the <Start> verb with <Stream>" do
    markup =
      twiml do
        start do
          stream url: "wss://example.com/audio" do
          end
        end
      end

    assert_twiml(markup, "<Start><Stream url=\"wss://example.com/audio\"></Stream></Start>")
  end

  test "can render the <Connect> verb with <Stream>" do
    markup =
      twiml do
        connect do
          stream url: "wss://example.com/audio" do
          end
        end
      end

    assert_twiml(markup, "<Connect><Stream url=\"wss://example.com/audio\"></Stream></Connect>")
  end

  test "can render <Stream> with all attributes" do
    markup =
      twiml do
        start do
          stream url: "wss://example.com/audio",
                 name: "my_stream",
                 track: "both_tracks",
                 status_callback: "https://example.com/callback",
                 status_callback_method: "GET" do
          end
        end
      end

    assert_twiml(
      markup,
      "<Start><Stream url=\"wss://example.com/audio\" name=\"my_stream\" track=\"both_tracks\" statusCallback=\"https://example.com/callback\" statusCallbackMethod=\"GET\"></Stream></Start>"
    )
  end

  test "can render <Stream> with nested <Parameter> elements" do
    markup =
      twiml do
        start do
          stream url: "wss://example.com/audio" do
            parameter name: "CustomerId", value: "12345"
            parameter name: "SessionId", value: "abc-123"
          end
        end
      end

    assert_twiml(
      markup,
      "<Start><Stream url=\"wss://example.com/audio\"><Parameter name=\"CustomerId\" value=\"12345\" /><Parameter name=\"SessionId\" value=\"abc-123\" /></Stream></Start>"
    )
  end

  test "can render the <Stop> verb with <Stream>" do
    markup =
      twiml do
        stop do
          stream name: "my_stream" do
          end
        end
      end

    assert_twiml(markup, "<Stop><Stream name=\"my_stream\"></Stream></Stop>")
  end

  test "can render a complete stream flow" do
    markup =
      twiml do
        start do
          stream url: "wss://example.com/audio", name: "call_stream" do
          end
        end
        say "Recording started"
        gather digits: 1 do
          say "Press 1 to stop recording"
        end
        stop do
          stream name: "call_stream" do
          end
        end
      end

    assert_twiml(
      markup,
      "<Start><Stream url=\"wss://example.com/audio\" name=\"call_stream\"></Stream></Start><Say>Recording started</Say><Gather digits=\"1\"><Say>Press 1 to stop recording</Say></Gather><Stop><Stream name=\"call_stream\"></Stream></Stop>"
    )
  end

  test "can render <Stream> with parameters and attributes" do
    markup =
      twiml do
        start do
          stream url: "wss://transcription-service.com/audio",
                 name: "call_transcript",
                 track: "both_tracks" do
            parameter name: "CallSid", value: "CA123456"
            parameter name: "Language", value: "en-US"
          end
        end
      end

    assert_twiml(
      markup,
      "<Start><Stream url=\"wss://transcription-service.com/audio\" name=\"call_transcript\" track=\"both_tracks\"><Parameter name=\"CallSid\" value=\"CA123456\" /><Parameter name=\"Language\" value=\"en-US\" /></Stream></Start>"
    )
  end

  test "can render the <Transcription> verb" do
    markup =
      twiml do
        transcription do
        end
      end

    assert_twiml(markup, "<Transcription></Transcription>")
  end

  test "can render the <Transcription> verb with attributes" do
    markup =
      twiml do
        transcription name: "call_transcript", language: "en-US" do
        end
      end

    assert_twiml(markup, "<Transcription name=\"call_transcript\" language=\"en-US\"></Transcription>")
  end

  test "can render the <Transcription> verb with track attribute" do
    markup =
      twiml do
        transcription track: "inbound_track" do
        end
      end

    assert_twiml(markup, "<Transcription track=\"inbound_track\"></Transcription>")
  end

  test "can render the <Transcription> verb with all common attributes" do
    markup =
      twiml do
        transcription name: "live_transcript",
                     track: "both_tracks",
                     language: "en-US",
                     status_callback: "https://example.com/transcription-status",
                     status_callback_method: "POST" do
        end
      end

    assert_twiml(
      markup,
      "<Transcription name=\"live_transcript\" track=\"both_tracks\" language=\"en-US\" statusCallback=\"https://example.com/transcription-status\" statusCallbackMethod=\"POST\"></Transcription>"
    )
  end

  test "can render <Transcription> nested inside <Start>" do
    markup =
      twiml do
        start do
          transcription name: "call_transcript", language: "en-US" do
          end
        end
      end

    assert_twiml(markup, "<Start><Transcription name=\"call_transcript\" language=\"en-US\"></Transcription></Start>")
  end

  test "can render <Transcription> with nested <Parameter> elements" do
    markup =
      twiml do
        transcription name: "call_transcript" do
          parameter name: "CallSid", value: "CA123456"
          parameter name: "AccountSid", value: "AC789012"
          parameter name: "CustomField", value: "custom_value"
        end
      end

    assert_twiml(
      markup,
      "<Transcription name=\"call_transcript\"><Parameter name=\"CallSid\" value=\"CA123456\" /><Parameter name=\"AccountSid\" value=\"AC789012\" /><Parameter name=\"CustomField\" value=\"custom_value\" /></Transcription>"
    )
  end

  test "can render multiple <Transcription> verbs" do
    markup =
      twiml do
        start do
          transcription name: "inbound_transcript", track: "inbound_track" do
          end
          transcription name: "outbound_transcript", track: "outbound_track" do
          end
        end
      end

    assert_twiml(
      markup,
      "<Start><Transcription name=\"inbound_transcript\" track=\"inbound_track\"></Transcription><Transcription name=\"outbound_transcript\" track=\"outbound_track\"></Transcription></Start>"
    )
  end

  test "can render a complete transcription flow" do
    markup =
      twiml do
        start do
          transcription name: "live_call_transcript",
                       language: "en-US",
                       track: "both_tracks" do
            parameter name: "CallSid", value: "CA123456"
            parameter name: "CustomerName", value: "John Doe"
          end
        end
        say "This call is being transcribed for quality assurance"
        gather digits: 1 do
          say "Press 1 to stop transcription"
        end
        stop do
          transcription name: "live_call_transcript" do
          end
        end
      end

    assert_twiml(
      markup,
      "<Start><Transcription name=\"live_call_transcript\" language=\"en-US\" track=\"both_tracks\"><Parameter name=\"CallSid\" value=\"CA123456\" /><Parameter name=\"CustomerName\" value=\"John Doe\" /></Transcription></Start><Say>This call is being transcribed for quality assurance</Say><Gather digits=\"1\"><Say>Press 1 to stop transcription</Say></Gather><Stop><Transcription name=\"live_call_transcript\"></Transcription></Stop>"
    )
  end

  test "can render <Transcription> with profanity filter" do
    markup =
      twiml do
        transcription name: "filtered_transcript",
                     profanity_filter: true do
        end
      end

    assert_twiml(markup, "<Transcription name=\"filtered_transcript\" profanityFilter=\"true\"></Transcription>")
  end

  test "can render <Transcription> with options as a variable" do
    options = [name: "dynamic_transcript", language: "es-ES", track: "inbound_track"]

    markup =
      twiml do
        transcription options do
        end
      end

    assert_twiml(markup, "<Transcription name=\"dynamic_transcript\" language=\"es-ES\" track=\"inbound_track\"></Transcription>")
  end

  defp assert_twiml(lhs, rhs) do
    assert lhs == "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response>#{rhs}</Response>"
  end
end
