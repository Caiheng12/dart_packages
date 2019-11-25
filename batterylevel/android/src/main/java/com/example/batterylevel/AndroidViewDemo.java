package com.example.batterylevel;

import android.content.Context;
import android.graphics.Color;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import org.json.JSONException;
import org.json.JSONObject;
import org.w3c.dom.Text;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.StreamHandler;
import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.platform.PlatformView;

public class AndroidViewDemo implements PlatformView, MethodCallHandler, StreamHandler {

    private BinaryMessenger  binaryMessenger;
    private View view = null;
    private TextView textView = null;
    private EditText editText = null;
    private Button sendButton = null;
    private MethodChannel methodChannel;
    private EventChannel eventChannel;
    private EventSink eventSink;
    private Registrar registrar;

    public AndroidViewDemo(int viewId,
                       BinaryMessenger messenger,
                       Registrar registrar,
                       Object o) {
        this.binaryMessenger = messenger;
        this.methodChannel = new MethodChannel(binaryMessenger, Constant.PLUGIN_PLAT_FORM_BASIC_VIEW_NAME + "_" + viewId);
        this.methodChannel.setMethodCallHandler(this);
        this.eventChannel =  new EventChannel(binaryMessenger, Constant.PLUGIN_PLAT_FORM_BASIC_VIEW_NAME + "_event_" + viewId);
        this.eventChannel.setStreamHandler(this);
        this.registrar = registrar;
        setupViews(registrar);
    }

    @Override
    public void onInputConnectionLocked() {

    }

    @Override
    public void onInputConnectionUnlocked() {

    }

    private void setupViews(Registrar registrar) {

        view = (View) LayoutInflater.from(registrar.activity()).inflate(R.layout.android_view, null);
        sendButton = view.findViewById(R.id.sendButton);
        sendButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                methodChannel.invokeMethod("flutterToEvalute", textView.getText());
            }
        });
        textView = view.findViewById(R.id.resultView);
        editText = view.findViewById(R.id.editText);
        editText.setHint("please in put text");
        editText.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

            }

            @Override
            public void afterTextChanged(Editable s) {
               // methodChannel.invokeMethod("flutterToEvalute", textView.getText());
            }
        });

    }

    @Override
    public void onMethodCall(MethodCall methodCall, Result result) {
        if (methodCall.method.equals("nativeToEvalute")) {
            if(methodCall.arguments instanceof String) {
                String text = (String)methodCall.arguments;
                try {
                    JSONObject text1 = new JSONObject("test");
                    System.out.println(text1);
                } catch (JSONException e) {
                    System.out.println(e.toString());
                }

            } else if (methodCall.arguments instanceof JSONObject) {
                JSONObject json = (JSONObject)methodCall.arguments;
                editText.setText(json.toString());
            }
        } else {
            result.notImplemented();
        }

    }

    @Override
    public void onListen(Object o, EventSink eventSink) {
        this.eventSink = eventSink;
    }

    @Override
    public void onCancel(Object o) {
        this.eventSink = null;
        this.eventChannel.setStreamHandler(null);
        this.methodChannel.setMethodCallHandler(null);
    }

    @Override
    public View getView() {
         return view;
    }

    @Override
    public void dispose() {
        methodChannel.setMethodCallHandler(null);
    }

    private void sinkText(String text) {
        methodChannel.invokeMethod("sendTextToFlutter", text);
    }
}
