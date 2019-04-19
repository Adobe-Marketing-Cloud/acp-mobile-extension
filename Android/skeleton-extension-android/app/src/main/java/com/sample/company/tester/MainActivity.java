/*
  ADOBE CONFIDENTIAL
  Copyright 2019 Adobe
  All Rights Reserved.
  NOTICE: Adobe permits you to use, modify, and distribute this file in
  accordance with the terms of the Adobe license agreement accompanying
  it. If you have received this file from a source other than Adobe,
  then your use, modification, or distribution of it requires the prior
  written permission of Adobe.
 */

package com.sample.company.tester;

import android.content.Context;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.TextView;

import com.adobe.marketing.mobile.MobileCore;
import com.sample.company.extension.SkeletonExtensionPublicApi;
import com.sample.company.extension.SkeletonExtensionCallback;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }

    @Override
    public void onResume() {
        super.onResume();
        MobileCore.lifecycleStart(null);
    }

    @Override
    public void onPause() {
        super.onPause();
        MobileCore.lifecyclePause();
    }

    public void onSetDataToExtension(final View view) {
        EditText editTextSetData = findViewById(R.id.etSetData);
        hideKeyboard(editTextSetData);
        if (editTextSetData == null || editTextSetData.getText() == null) {
            return;
        }

        String dataToSend = editTextSetData.getText().toString();

        SkeletonExtensionPublicApi.setterExample(dataToSend);
    }

    public void onGetDataFromExtension(final View view) {
        final TextView textViewGetData = findViewById(R.id.tvGetData);
        if (textViewGetData == null) {
            return;
        }

        SkeletonExtensionPublicApi.getterExample(new SkeletonExtensionCallback() {
            @Override
            public void call(final String data) {
                view.post(new Runnable() {
                    @Override
                    public void run() {
                        textViewGetData.setText(data);
                    }
                });
            }
        });
    }

    private void hideKeyboard(final EditText editText) {
        InputMethodManager inputMethodManager = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);
        if (inputMethodManager != null && editText != null) {
            inputMethodManager.hideSoftInputFromWindow(editText.getWindowToken(), 0);
        }
    }
}
