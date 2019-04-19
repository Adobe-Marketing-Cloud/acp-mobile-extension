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

package com.sample.company.extension;

/**
 * Callback interface used by {@link SkeletonExtensionPublicApi} to return requested information
 * from the {@link SkeletonExtension} back to the calling application.
 */
public interface SkeletonExtensionCallback {
    /**
     * Called when the {@link SkeletonExtension} is finshed processing a getter request for
     * {@code String} information.
     *
     * @param data the requested information from the {@code SkeletonExtension}, may be null
     */
    void call(final String data);
}
