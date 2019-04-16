package com.sample.company.tester;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
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
        if (editTextSetData == null || editTextSetData.getText() == null) {
            return;
        }

        String dataToSend = editTextSetData.getText().toString();

        SkeletonExtensionPublicApi.setRequestForExtension(dataToSend);
    }

    public void onGetDataFromExtension(final View view) {
        final TextView textViewGetData = findViewById(R.id.tvGetData);
        if (textViewGetData == null) {
            return;
        }

        SkeletonExtensionPublicApi.getRequestFromExtension(new SkeletonExtensionCallback() {
            @Override
            public void call(String data) {
                textViewGetData.setText(data);
            }
        });
    }
}
